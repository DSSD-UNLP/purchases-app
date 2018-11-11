class External::ProductType
  require 'net/http'
  include ActiveModel::Model

  URL = '/stock/types/'.freeze

  attr_accessor :id, :name, :description

  def self.all(pages:, page_url: nil)
    request =
      if page_url.present?
        Net::HTTP::Get.new(URI.parse(page_url).request_uri)
      else
        params   = pages.to_query
        uri      = URI.parse(URL + '?' + params).to_s
        Net::HTTP::Get.new(uri)
      end

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
