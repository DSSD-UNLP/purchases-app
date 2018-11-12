module ApplicationHelper
  def disabled_next
    @manager.products_next_page.present? ? '' : 'disabled'
  end

  def disabled_previous
    @manager.products_previous_page.present? ? '' : 'disabled'
  end

  def products_next_page_number
    return unless @manager.products_next_page.present?

    Rack::Utils.parse_query(URI(@manager.products_next_page).query)['page']
  end

  def products_previous_page_number
    return unless @manager.products_previous_page.present?

    Rack::Utils.parse_query(URI(@manager.products_previous_page).query)['page']
  end
end
