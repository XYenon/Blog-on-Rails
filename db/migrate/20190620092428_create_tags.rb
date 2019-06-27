class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    add_index :tags, :name, unique: true

    create_join_table :articles, :tags do |t|
      t.belongs_to :article, foreign_key: true
      t.belongs_to :tag, foreign_key: true
    end
  end
end
