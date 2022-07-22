# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  blurb      :string
#  body       :text
#  cta        :string
#  identifier :string(8)        not null
#  image_url  :string
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_posts_on_identifier  (identifier) UNIQUE
#
class Post < ApplicationRecord
  IDENTIFIER_LENGTH = 6

  validates :title, presence: true, length: { in: 3..80 }

  before_create :set_identifier

  private

  def set_identifier
    self[:identifier] = generate_identifier
    return unless idenfitier_exists?

    # Recursively call #generate_identifier if it already exists
    set_identifier
  end

  # The default length SecureRandom.base58(6) allows 38B possibilities
  def generate_identifier
    SecureRandom.base58(IDENTIFIER_LENGTH)
  end

  def idenfitier_exists?
    self.class.exists?(identifier: self[:identifier])
  end
end
