# frozen_string_literal: true

module Widgets
  class EmbedCodeComponent < ApplicationComponent
    attr_reader :item, :opts

    def initialize(item:, opts: {})
      @item = item
      @opts = opts
    end
  end
end
