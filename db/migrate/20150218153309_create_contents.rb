class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :title
      t.string :tags
      t.timestamps null: false
      t.string :file
    end

  end
end
