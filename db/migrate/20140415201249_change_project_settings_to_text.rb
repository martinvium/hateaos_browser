class ChangeProjectSettingsToText < ActiveRecord::Migration
  def change
    change_column :projects, :settings, :text
  end
end
