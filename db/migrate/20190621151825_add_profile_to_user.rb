class AddProfileToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :profile, :string, default: 'Hello World!'
  end
end
