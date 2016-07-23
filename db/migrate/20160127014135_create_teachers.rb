class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.string :title
      
      t.timestamps null: false
    end

    create_table :teachers do |t|
      t.string  :name
      t.integer :title_id, :index => true
      t.string  :education
      t.text    :specialty
      t.string  :contact
      t.string  :email
      t.string  :note
      t.float   :default_ratio

      t.string  :account
      t.string  :password
      t.string  :salt
      t.string  :confirm, :index => true

      t.timestamps null: false
    end

    create_table :teacher_categoryships do |t|
      t.integer :teacher_id, :index => true
      t.integer :category_id, :index => true
      
      t.timestamps null: false
    end

    create_table :categories do |t|
      t.string :category
      
      t.timestamps null: false
    end
  end
end
