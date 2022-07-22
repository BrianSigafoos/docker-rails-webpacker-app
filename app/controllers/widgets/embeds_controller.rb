# frozen_string_literal: true

module Widgets
  class EmbedsController < ApplicationController
    layout 'blank'

    def show
      @item = item
    end

    private

    def item
      @item ||= Post.find_by(identifier: params_id)
    end

    # Fall back to first
    def params_id
      params[:id].presence || Post.first.identifier
    end
  end
end
