# frozen_string_literal: true

require 'test_helper'

module Widgets
  class EmbedCodeComponentTest < ViewComponent::TestCase
    def component
      Widgets::EmbedCodeComponent
    end

    test 'component renders with embed code' do
      post = posts(:one)
      render_inline component.new(item: post)

      assert_text 'Embed'
      embed_code_start = '<div class="demoapp demoapp-widget"><script src='
      assert_text embed_code_start
      assert_text widget_src_url(post)
      assert_text Widgets::EmbedCodeSnippetComponent::SEO_LINK_URL
      assert_text '</script>'
    end

    def widget_src_url(item)
      "#{ENV.fetch('DEFAULT_URL_OPTS_PROTOCOL')}" \
        "#{ENV.fetch('DEFAULT_URL_OPTS_HOST')}/widgets/#{item.identifier}.js"
    end
  end
end
