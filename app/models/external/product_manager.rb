class External::ProductManager
  include ActiveModel::Model

  attr_reader :total_products, :products_next_page, :products_previous_page,
              :total_types, :types_next_page, :types_previous_page

  def products
    response                = External::Product.all
    @total_products         = response[:count]
    @products_next_page     = response[:next]
    @products_previous_page = response[:previous]

    response[:results]
  end

  def types
    response              = External::ProductType.all
    @total_types          = response[:count]
    @types_next_page      = response[:next]
    @types_previous_page  = response[:previous]

    response[:results]
  end
end
