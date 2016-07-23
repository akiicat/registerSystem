class ApplicationMailer < ActionMailer::Base
  layout 'mailer'  
  default :from => %w(nctuee <noreply@exam.ee.nctu.edu.tw>)
  before_action :domain_url
  append_view_path("#{Rails.root}/app/views/mailers")

private
  def domain_url
    domain     = "http://" + ENV['DOMAIN']
    @guest_url = domain
    @user_url  = domain + '/user/login'
    @admin_url = domain + '/admin/login'
  end

end
