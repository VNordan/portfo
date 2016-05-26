class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  @@partName = "КП УГС"

  helper_method :partName

  def partName
    @@partName
  end

  after_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        request.fullpath != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
          session[:previous_url] = request.referrer
    end
  end

  def after_sign_in_path_for(resource)
    #request.referrer
    #session[:previous_url] || root_path
    main_app.root_url
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => 'У вас нет прав доступа к этой странице' #exception.message
  end
end