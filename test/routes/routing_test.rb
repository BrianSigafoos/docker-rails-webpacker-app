# frozen_string_literal: true

require 'test_helper'

class RoutingTest < ActionDispatch::IntegrationTest
  test '/ aka root path' do
    assert_routing(url('/'), controller: 'homepages', action: 'show')
  end

  test '/widgets' do
    assert_routing(url('/widgets/A1234Z'), controller: 'widgets/widgets',
                   action: 'show', id: 'A1234Z')
  end

  test '/embed' do
    assert_routing(url('/embed'), controller: 'widgets/embeds', action: 'show')
  end

  test '/health_check' do
    assert_routing(url('/health_check'), controller: 'health_checks',
                                         action:     'show')
  end

  def url(path, host = ENV.fetch('DEFAULT_URL_OPTS_HOST'))
    "https://#{host}#{path}"
  end
end
