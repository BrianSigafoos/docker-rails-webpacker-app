# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :cta
      t.string :blurb
      t.text   :body
      t.string :image_url
      t.string :identifier, null: false, limit: 8

      t.index :identifier, unique: true

      t.timestamps
    end
  end
end
