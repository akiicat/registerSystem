class Student < ActiveRecord::Base

  belongs_to :group
  belongs_to :vacancy

  # Teacher Element
  # has_many  :teachers  , :through   => :vacancies

  # Store
  store     :contact  , :accessors => [:phone]

  # Validates
  validates :name     , :presence    => true
  validates :email    , :presence    => true, :uniqueness => true, format: /@/
  validates :studentID, :allow_blank => true, :uniqueness => true
  validates :year     , :presence    => true
  validates :status   , :presence    => true, inclusion: { in: %w(waiting inviting completed) }

  validates :confirm  , :presence    => true

  # Callback
  # after_destory :vacancy
  # after_save
  # after_update
  before_validation :default_create, :on => :create

  protected

  # Create Set Student.confirm
  def default_create
    self.confirm = SecureRandom.hex if self.confirm.blank?
  end

  def self.all_sort_by_name
    all.sort do |x, y|
      rtn = 0
      x.name.length.times do |i|
        break if rtn != 0
        begin
          rtn = x.name[i].encode("BIG5") <=> y.name[i].encode("BIG5")
        rescue Exception => e
          break
        end
      end
      rtn
    end
  end

end
