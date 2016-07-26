class AddStudentsEntry < ActiveRecord::Migration
  def change
    add_column :students, :entry, :string
  end
end
