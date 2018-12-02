class PurchasesController < ApplicationController
  before_action :set_product
  before_action :set_coupon

  def new
    case_id = BonitaManager.new.start_case(start_case_params)
  end

  def create
  end

  private

  def start_case_params
    {
      'processDefinitionId': '4751000970449300331',
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
