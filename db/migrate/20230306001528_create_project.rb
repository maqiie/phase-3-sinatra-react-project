class CreateProject < ActiveRecord::Migration[6.1]
  def change
    create_table :Projects do |t|
      t.string :title
      t.string :description
    end
  end
end
