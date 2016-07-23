class Vacancy < ActiveRecord::Base
  # Scope
  # default_scope { order('group_id') } 

  # Belong
  belongs_to :teacher

  # Student
  has_many :students, :dependent => :nullify

  # Validates
  validates :confirm, :presence  => true

  # Callback
  # before_validation :default_create_vacancy , :on => :create
  # before_validation :update_remain_counter, :on => :update

  # after_destory :destory_vacancy
  before_validation :default_create, :on => :create

  protected

  # Create set salt
  def default_create
    self.confirm = SecureRandom.hex if self.confirm.blank?
  end

  # Create Set Vacancy.number remain counters confirm
  # def default_create_vacancy
  #   self.number                  = 0.0 if self.number.blank?
  #   self.remain                  = 0.0 if self.remain.blank?

  #   self.students_count          = 0   if self.students_count.blank?
  #   self.inviting_students_count = 0   if self.inviting_students_count.blank?
  #   self.coop_students_count     = 0   if self.coop_students_count.blank?
  #   self.noco_students_count     = 0   if self.noco_students_count.blank?

  #   self.confirm = SecureRandom.hex    if self.confirm.blank?
  # end

  # # Update Set Remain
  # def update_remain_counter
  #   ratio = self.field.ratio
  #   self.remain = self.number - (self.noco_students_count.to_f + ratio * self.coop_students_count.to_f)
  # end
end
