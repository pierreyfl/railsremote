class TweakJobFields < ActiveRecord::Migration
  def change
    remove_column :jobs, :employees_in
    add_column :jobs, :timezone_preferences, :string, limit: 255
    add_column :jobs, :timezone_preferences_description, :text
    add_column :jobs, :agencies_ok, :boolean, default: false, null: false
  end
end
