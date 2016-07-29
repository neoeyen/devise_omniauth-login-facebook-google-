class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :image, :string
    # add_column :users, :re_pw_reset, :boolean
  end
end
