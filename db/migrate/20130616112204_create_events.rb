class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :content
      t.string :status
      t.attachment :image
      t.timestamps
    end
  end
end
