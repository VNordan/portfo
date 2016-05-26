class CreateDepartmentGroups < ActiveRecord::Migration
  def change
    create_table :department_groups do |t|
      t.string :name
      t.integer :order
    end


    change_table :employee_stats_departments do |t|
      t.belongs_to :department_group
    end
  end
end
