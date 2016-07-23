class Group < ActiveRecord::Base
  # Scope
  default_scope { order(:created_at => :asc) }

  # Vacancy Element
  has_many :students  , :dependent => :nullify
  accepts_nested_attributes_for :students, allow_destroy: false

  # Student
  has_many :vacancies , :through   => :students

  # Validates
  validates :group    , :presence  => true, :uniqueness => true

  # Callback
  #after_create  :create_group
  #after_destory :destory_group

  protected

  # Create Set Vacancy
  # def create_vacancies
  #   Group.transaction do
  #     Field.find_each do |f|
  #       Vacancy.create!(
  #           :group_id => self.id,
  #           :field_id => f.id)
  #     end
  #   end 
  # end

  # def create_group

  # end
  # def destory_group

  # end
end
