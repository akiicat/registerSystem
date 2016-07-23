class Develop::ApplicationController < ApplicationController
  before_action :authenticate

protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      Digest::SHA1.hexdigest(password)
      username == ENV['DEV_USERNAME'] && password == ENV['DEV_PASSWORD']
    end
  end
end
