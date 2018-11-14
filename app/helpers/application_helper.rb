module ApplicationHelper
  def disabled_next
    @products.next.present? ? '' : 'disabled'
  end

  def disabled_previous
    @products.previous.present? ? '' : 'disabled'
  end

  def products_next_page_number
    return unless @products.next.present?

    Rack::Utils.parse_query(URI(@products.next).query)['page']
  end

  def products_previous_page_number
    return unless @products.previous.present?

    Rack::Utils.parse_query(URI(@products.previous).query)['page']
  end
end
