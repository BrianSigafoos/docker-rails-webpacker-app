# frozen_string_literal: true

module Widgets
  class WidgetsController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :find_item

    layout false

    def show
      @item = item

      respond_to do |format|
        format.js { render }
        format.any(:html, :json, :csv) { head :bad_request }
      end
    end

    private

    def find_item
      return if params[:id].present? && item.present?

      # TODO: return friendlier message of 'Not found'
      render_error(404)
    end

    # TODO: replace with DB call + local seeds
    def item
      {
        name:        'My Totally Awesome Item 👋',
        description: 'This is as good as it gets'
      }.with_indifferent_access
    end
  end
end
