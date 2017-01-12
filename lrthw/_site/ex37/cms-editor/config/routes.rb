Rails.application.routes.draw do
  root 'content_items#index'

  get 'secureheaderscheck' => 'secure_headers_check#index'

  get 'error/index'
  get 'error/no_permissions'

  get '/delete' => 'admin#delete', :as => 'delete'

  get '/logout' => 'application#logout'
  get '/content-type-list' => 'application#content-type-list', :as => 'content_type_list'
  get '/permission-denied' => 'application#permission-denied', :as => 'permission_denied'

  get 'discard/index'

  resources :announcements,
            :campaigns,
            :case_studies,
            :corporate_informations,
            :collections,
            :events,
            :external_items,
            :groups,
            :guides,
            :labels,
            :locations,
            :organisations,
            :organisation_landing_pages,
            :person_profiles,
            :projects,
            :publications,
            :service_starts,
            :team_profiles,
            :users
end
