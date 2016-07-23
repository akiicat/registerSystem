class CreateFields < ActiveRecord::Migration
  def change

    create_table :groups do |t|
      t.string :group
      
      t.timestamps null: false
    end

    create_table :vacancies do |t|
      t.integer :teacher_id, :index => true

      t.integer :year
      t.boolean :archive

      t.float   :ratio

      t.string  :number
      t.string  :used

      t.string  :confirm, :index => true

      t.timestamps null: false
    end

    create_table :students do |t|
      t.integer :group_id, :index => true
      t.integer :entry_group_id

      ## store vacancy id 
      t.integer :vacancy_id, :index => true
      t.integer :coop_vacancy_id, :index => true

      t.boolean :personal
      t.boolean :coop_personal

      ## store teacher id
      t.integer :replaced_id
      t.integer :coop_replaced_id

      t.integer :year # 入學年份

      t.string  :status
      t.boolean :coop
      t.boolean :repl
      t.integer :waiting_list

      t.string :name
      t.string :email
      t.string :contact
      t.string :studentID

      t.string :confirm, :index => true

      t.timestamps null: false
    end
  end
end
