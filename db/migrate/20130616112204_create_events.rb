class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :content
      t.string :status
      t.string :author
      t.string :label
      t.string :label_link
      t.boolean :featured
      t.attachment :image
      t.timestamps
    end
  end
end
