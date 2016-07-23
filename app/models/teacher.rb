class Teacher < ActiveRecord::Base
  # Scope
  # default_scope { order(:name => :asc) }

  # Teacher Element
  belongs_to :title
  has_many :teacher_categoryships, :dependent => :destroy
  has_many :categories, :through   => :teacher_categoryships

  # Vacancy Element
  has_many :vacancies, :dependent => :destroy

  # Student
  # has_many :students  , :through   => :vacancies

  # Store
  store     :contact  , :accessors => [:phoneO, :phoneL, :officeO, :officeL]

  # Validates
  validates :name     , :presence  => true
  validates :email    , :presence  => true, :uniqueness => true, format: /@/
  #validates :email    , :presence  => true, format: /@/
  validates :default_ratio, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }

  validates :account  , :presence  => true, :uniqueness => true
  validates :password , :presence  => true
  validates :salt     , :presence  => true
  validates :confirm  , :presence  => true
  
  # Callback
  before_validation :default_create, :on => :create

  protected

  # Create Set Teacher.salt
  def default_create
    self.salt = SecureRandom.hex if self.salt.blank?
    self.confirm = SecureRandom.hex if self.confirm.blank?
    self.default_ratio = 0.5 if self.default_ratio.blank?
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

  def self.search_sort_by_name(search)
    sql = ''
    sql << 'UPPER(name)      LIKE UPPER(:search) OR '
    sql << 'UPPER(specialty) LIKE UPPER(:search) OR '
    sql << 'UPPER(email)     LIKE UPPER(:search) OR '
    sql << 'UPPER(education) LIKE UPPER(:search)'
    where(sql, search: "%#{search}%").sort do |x, y|
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

  def self.search(search)
    if search
      self.search_sort_by_name(search)
    else
      self.all_sort_by_name
    end
  end
end
