# frozen_string_literal: true

module Widgets
  class ItemComponent < ApplicationComponent
    attr_reader :item

    def initialize(item:)
      @item = item
    end
  end
end
