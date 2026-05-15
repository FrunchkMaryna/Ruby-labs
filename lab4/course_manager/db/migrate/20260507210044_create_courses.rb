class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :category
      t.string :main_topic
      t.integer :duration_hours
      t.date :start_date
      t.date :end_date
      t.float :price
      t.integer :status

      t.timestamps
    end
  end
end
