class External::Coupon
  include ActiveModel::Model
  extend ActiveModel::Naming
  require 'net/http'

  URL = '/coupons/'.freeze
  attr_accessor :name
  attr_reader   :errors

  def initialize(params)
    @errors = ActiveModel::Errors.new(self)

    super(params)
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def self.human_attribute_name(attr, options = {})
    attr
  end

  def self.lookup_ancestors
    [self]
  end

  def validate!
    request  = Net::HTTP::Get.new(URL + "#{name}/")
    response = Net::HTTP.new(
      ENV['COUPON_API_HOST'],
      ENV['COUPON_API_PORT']
    ).request(request)

    result = JSON.parse(response.body).with_indifferent_access

    return if result[:availability]

    errors.add(:name, :invalid_coupon, message: 'El cupon no es válido')
  end
end
