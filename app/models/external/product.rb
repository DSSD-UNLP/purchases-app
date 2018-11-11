class External::Product
  require 'net/http'
  include ActiveModel::Model

  URL = '/stock/products/'.freeze

  attr_accessor :name, :cost_price, :sale_price,
                :product_type, :id, :image, :stock

  def self.all(pages:)
    params   = pages.to_query
    uri      = URI.parse(URL + '?' + params).to_s
    request  = Net::HTTP::Get.new(uri)
    response = Net::HTTP.new(
      ENV['STOCK_API_HOST'],
      ENV['STOCK_API_POST']
    ).request(request)
    results = JSON.parse(response.body).with_indifferent_access

    results[:results].map! do |product|
      External::Product.new(product)
    end

    results
  end

  def self.single(id)
    request  = Net::HTTP::Get.new("/stock/product/#{id}/")
    response = Net::HTTP.new(
      ENV['STOCK_API_HOST'],
      ENV['STOCK_API_POST']
    ).request(request)

    result = JSON.parse(response.body).with_indifferent_access

    External::Product.new(result)
  end
end
