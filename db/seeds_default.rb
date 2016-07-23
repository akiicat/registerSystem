# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Title.create!(:id => 1, :title => "教授")
Title.create!(:id => 2, :title => "副教授")
Title.create!(:id => 3, :title => "助理教授")
Title.create!(:id => 4, :title => "合聘教授")
Title.create!(:id => 5, :title => "講座教授")
Title.create!(:id => 6, :title => "特聘教授")
Title.create!(:id => 7, :title => "教授兼主任")
Title.create!(:id => 8, :title => "教授兼所長")

Category.create!(:id => 1, :category => "元件、材料、物理、電磁學群")
Category.create!(:id => 2, :category => "程式設計、數位系統、數位電路學群")
Category.create!(:id => 3, :category => "類比電路學群")
Category.create!(:id => 4, :category => "訊號與系統、通訊、控制學群")
Category.create!(:id => 5, :category => "生醫電子、光電學群")

Group.create!(:id => 1, :group => "甄試甲 (固態)")
Group.create!(:id => 2, :group => "甄試乙A (類比)")
Group.create!(:id => 3, :group => "甄試乙B (數位通訊EDA)")
Group.create!(:id => 4, :group => "入學甲 (固態)")
Group.create!(:id => 5, :group => "入學乙A (類比)")
Group.create!(:id => 6, :group => "入學乙B (通訊)")
Group.create!(:id => 7, :group => "入學乙C (數位通訊EDA)")
Group.create!(:id => 8, :group => "個人名額")

Admin.create!(
    :id       => "1",
    :account  => "name",
    :password => SecureRandom.hex,
    :salt     => SecureRandom.hex,
    :name     => "name",
    :email    => "your_email_here")

