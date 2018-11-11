class External::ProductManager
  include ActiveModel::Model

  attr_reader :total_products, :products_next_page, :products_previous_page,
              :total_types, :types_next_page, :types_previous_page

  def products_next_page_number
    return unless products_next_page.present?

    Rack::Utils.parse_query(URI(products_next_page).query)['page']
  end

  def products_previous_page_number
    return unless products_previous_page.present?

    Rack::Utils.parse_query(URI(products_previous_page).query)['page']
  end

  def products(params)
    response = External::Product.all(
      pages: {
        page: (params[:page] || 1),
        page_size: (params[:per_page] || 2)
      }
    )
    @total_products         = response[:count]
    @products_next_page     = response[:next]
    @products_previous_page = response[:previous]

    response[:results]
  end

  def types(page: nil, per_page: nil, page_url: nil)
    response = External::ProductType.all(
      pages: {
        page: (page || 1),
        page_size: (per_page || 2)
      },
      page_url: page_url
    )
    @total_types          = response[:count]
    @types_next_page      = response[:next]
    @types_previous_page  = response[:previous]

    response[:results]
  end

  def single(id)
    External::Product.single(id)
  end

  def list_types
    all_types = types(per_page: 5)

    while types_next_page.present? do
      all_types += types(page_url: types_next_page)
    end

    all_types
  end
end
