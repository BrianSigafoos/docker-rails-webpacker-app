# frozen_string_literal: true

module Widgets
  class EmbedCodeSnippetComponent < ApplicationComponent
    SEO_LINK_TXT = 'Docker Rails Demo App'
    SEO_LINK_URL = 'https://github.com/BrianSigafoos/docker-rails-webpacker-app'

    attr_reader :item

    def initialize(item:)
      @item = item
    end

    def call
      embed_code
    end

    def embed_code
      tag.div(class: 'demoapp demoapp-widget') do
        concat(tag.script(src: widget_src_url))
        concat(seo_footer)
      end
    end

    private

    def widget_src_url
      "#{widget_src_prefix}/widgets/#{item.identifier}.js"
    end

    def widget_src_prefix
      return 'http://localhost:3000' if Rails.env.development?

      ''
    end

    def seo_footer
      tag.p do
        concat('Widget created with ')
        concat(link_to(SEO_LINK_TXT, SEO_LINK_URL))
        concat(' by Brian')
      end
    end
  end
end
