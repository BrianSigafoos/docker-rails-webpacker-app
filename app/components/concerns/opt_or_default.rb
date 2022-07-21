# frozen_string_literal: true

module OptOrDefault
  extend ActiveSupport::Concern

  private

  def opt_or_default(key)
    return opts[key] unless opts[key].nil?

    self.class::DEFAULT_OPTS[key]
  end
end
