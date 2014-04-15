class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :root
      t.string :settings

      t.timestamps
    end
  end
end
