class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization

  before_filter :set_layout_vars
  helper_method :current_user_session, :current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private
    def set_layout_vars
      @user_session = UserSession.new
      @random_quote = Quote.random
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        flash[:notice] = 'Vous devez être connecté pour accéder à cette page.'
        redirect_to :login
        return false
      end
    end

    def require_no_user
      if current_user
        flash[:notice] = 'Vous ne pouvez pas faire ça car vous être connecté.'
        redirect_to :root
        return false
      end
    end
end
