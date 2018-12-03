class ApplicationController < ActionController::Base
  BONITA_HOST_URL = ENV['BONITA_HOST_URL']

  before_action :finish_previous_case

  private

  def finish_previous_case
    if request.referrer&.include? 'purchases/new'
      return if (params[:controller] == 'purchases') && (params[:action] == 'create')

      last_case = Rails.cache.read("#{BONITA_HOST_URL}/last_case")
      BonitaManager.new(last_case).finish_case_with_error if last_case.present?
    end
  end
end
