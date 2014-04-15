HateaosBrowser::Application.routes.draw do
  resource :resource, only: [] do
    get :get
    post :post
    put :put
    delete :delete
  end

  root "application#home"
end
