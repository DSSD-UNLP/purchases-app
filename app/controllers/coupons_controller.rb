class CouponsController < ApplicationController
  def validate
    @coupon = External::Coupon.new(coupon_params)

    @coupon.validate!
  end

  private

  def coupon_params
    params.permit(:name)
  end
end
