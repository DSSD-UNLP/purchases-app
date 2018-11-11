module ApplicationHelper
  def disabled_next
    @manager.products_next_page.present? ? '' : 'disabled'
  end

  def disabled_previous
    @manager.products_previous_page.present? ? '' : 'disabled'
  end
end
