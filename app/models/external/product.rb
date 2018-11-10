class External::Product
  require 'net/http'
  include ActiveModel::Model

  attr_accessor :name, :cost_price, :sale_price, :product_type, :id

  def self.all
    request  = Net::HTTP::Get.new('/stock/products/')
    response = Net::HTTP.new(
      ENV['STOCK_API_HOST'],
      ENV['STOCK_API_POST']
    ).request(request)

    results = JSON.parse(response.body).with_indifferent_access

    results[:results].map do |product|
      External::Product.new(product)
    end
  end
end
