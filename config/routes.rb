Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }
  scope module: :api do
    scope module: :v1 do
      resources :trains, only: %i[index show create] do
        get :withdraw, on: :member
      end
      resources :parcels, only: %i[index show create] do
        get :retrieve, on: :member
      end
      resources :bookings, only: %i[index create]
    end
  end
end
