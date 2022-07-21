# frozen_string_literal: true

class HealthChecksController < ApplicationController
  def show
    # TODO: check db and redis. See https://github.com/ianheggie/health_check
    head :ok
  end
end
