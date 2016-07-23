class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email

      t.string :account
      t.string :password
      t.string :salt
      t.string :confirm, :index => true

      t.timestamps null: false
    end
  end
end
