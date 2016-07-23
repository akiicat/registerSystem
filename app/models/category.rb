class Category < ActiveRecord::Base
  # Scope
  default_scope { order(:created_at => :asc) }

  # Teacher
  has_many :teacher_categoryships, :dependent => :destroy
  has_many :teachers, :through => :teacher_categoryships

  # Validates
  validates :category, :presence => true, :uniqueness => true
end
