class CouponsController < ApplicationController
  before_action :set_product

  def new
    @coupon = External::Coupon.new
  end

  def validate
    @coupon = External::Coupon.find(coupon_params[:name])

    if @coupon.valid?
      flash[:notice] = 'El cupón ingresado es válido'

      redirect_to new_product_purchase_path(@product.id, params: @coupon)
    else
      flash[:alert] = 'El cupón ingresado no es válido'

      render :new
    end
  end

  private

  def coupon_params
    params.require(:external_coupon).permit(:name)
  end

  def set_product
    @product = External::Product.find(params[:product_id])
  end
end
