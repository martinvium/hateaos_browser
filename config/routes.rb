HateaosBrowser::Application.routes.draw do
  resources :projects do
    resource :resource, only: [] do
      # collection do
        get 'get'# => "resource#get"
        # post :post => "resource#get"
        # put :put => "resource#get"
        # delete :delete => "resource#get"
      # end
    end
  end

  root "application#home"
end
