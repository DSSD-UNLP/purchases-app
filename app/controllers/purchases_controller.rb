class PurchasesController < ApplicationController
  PROCESS_DEFINITION_ID = ENV['PROCESS_DEFINITION_ID']

  before_action :set_product
  before_action :set_coupon

  def new
    @manager = BonitaManager.new
    @manager.start_case(start_case_params)
    sleep 5.seconds
  end

  def create
    @manager = BonitaManager.new(params[:case_id]).finish_case_successfully
    redirect_to root_path, notice: 'Compra realizada con éxito'
  end

  private

  def start_case_params
    {
      'processDefinitionId': PROCESS_DEFINITION_ID,
      'variables': [
        {
          'name': 'nombrecupon',
          'value': (@coupon&.name || '')
        },
        {
          'name': 'email',
          'value': current_user.email
        },
        {
          'name': 'id_producto',
          'value': @product.id.to_s
        },
        {
          'name': 'tipo_producto',
          'value': @product.type.name
        }
      ]
    }
  end

  def set_coupon
    return unless params[:name].present?

    @coupon = External::Coupon.find(params[:name])
    @coupon = nil unless @coupon.valid?
  end

  def set_product
    @product = External::Product.find(params[:product_id])
  end
end
