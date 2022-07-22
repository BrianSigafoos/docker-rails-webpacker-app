# frozen_string_literal: true

class ToggleColorButtonsComponent < ApplicationComponent
  attr_reader :icon_size, :color_primary, :show_labels, :cls, :focus_ring

  def initialize(icon_size: 'h-6 w-6', color_primary: true, show_labels: true,
                 cls: nil, focus_ring: true)
    @icon_size = icon_size
    @color_primary = color_primary
    @show_labels = show_labels
    @cls = cls || default_cls
    @focus_ring = focus_ring
  end

  private

  def default_cls
    'p-3'
  end
end
