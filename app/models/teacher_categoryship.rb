class TeacherCategoryship < ActiveRecord::Base
  # Teacher Category ship
  belongs_to :teacher
  belongs_to :category
end
