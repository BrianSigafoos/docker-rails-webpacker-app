# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :widgets do
    resources :widgets, only: :show
    resource  :embed,   only: :show
  end

  resource :health_check, only: :show

  root 'homepages#show'
end
