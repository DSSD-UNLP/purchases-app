class External::Coupon < Flexirest::Base
  extend ActiveModel::Naming
  include ActiveModel::Validations

  validates_each :availability do |record, attr, value|
    record.errors.add(attr, :invalid_coupon, message: 'El cupon no es válido') unless value
  end

  base_url ENV['COUPON_API_URL']

  get :find, '/coupons/:id/'
end
