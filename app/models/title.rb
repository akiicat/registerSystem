class Title < ActiveRecord::Base
  # Scope
  default_scope { order(:created_at => :asc) }

  # Teacher Element
  has_many :teachers  , :dependent => :nullify

  # Validates
  validates :title, :presence => true, :uniqueness => true
end
