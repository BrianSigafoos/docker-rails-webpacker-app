# frozen_string_literal: true

module Widgets
  class EmbedsController < ApplicationController
    layout 'blank'

    def show
      @item = Struct.new(:identifier)
                    .new(SecureRandom.base58(6))
    end
  end
end
