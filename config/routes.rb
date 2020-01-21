Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    # Api
    namespace :api, defaults: { format: :json } do
      post 'hotels/search', to: 'hotels#search'

      match '*path', to: 'base#catch_404', via: :all
    end
end
