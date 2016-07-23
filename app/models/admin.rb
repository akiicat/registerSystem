class Admin < ActiveRecord::Base
  # Validates
  validates :email,     :presence => true, :uniqueness => true, format: /@/
  validates :email    , :presence => true, format: /@/

  validates :account  , :presence => true, :uniqueness => true
  validates :password , :presence => true

  validates :salt     , :presence => true
  validates :confirm  , :presence => true

  # Callback
  before_validation :default_create, :on => :create

  protected

  # Create set salt
  def default_create
    self.salt    = SecureRandom.hex if self.salt.blank?
    self.confirm = SecureRandom.hex if self.confirm.blank?
  end
end
