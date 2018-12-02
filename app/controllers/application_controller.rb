class ApplicationController < ActionController::Base
  BONITA_HOST_URL = ENV['BONITA_HOST_URL']

  # before_action :finish_previous_case

  private

  def finish_previous_case
    if request.referrer.include? 'purchases/new'
      last_case = Rails.cache.read("#{BONITA_HOST_URL}/last_case")
    end
  end
end
