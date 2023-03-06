class AddPasswordHashToUsers < ActiveRecord::Migration[6.1]
    def change
      add_column :users, :passwordHash, :string
    end
  end
  