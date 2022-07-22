# frozen_string_literal: true

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test 'before_create #set_identifier' do
    p1 = Post.new(title: SecureRandom.hex)
    assert_nil p1.identifier
    p1.save!
    assert_not_nil p1.reload.identifier

    p2 = Post.new(title: SecureRandom.hex, identifier: p1.identifier)
    assert_predicate p2, :valid?
    p2.save!
    assert_not_equal p1.identifier, p2.identifier
  end
end
