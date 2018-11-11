class External::ProductType
  require 'net/http'
  include ActiveModel::Model

  attr_accessor :name, :description

  def self.all
    request  = Net::HTTP::Get.new('/stock/types/')
    response = Net::HTTP.new(
      ENV['STOCK_API_HOST'],
      ENV['STOCK_API_POST']
    ).request(request)

    results = JSON.parse(response.body).with_indifferent_access

    results[:results].map! do |type|
      External::ProductType.new(type)
    end

    results
  end
end
