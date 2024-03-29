class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_ordered_categories
  before_action :set_default_title

  private

    def set_ordered_categories
      @categories = Luton::Cache.fetch('ordered_categories') do
        Category.ordered
      end
    end

    def set_default_title
      @title = "Minecraft for Parents"
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    def admin_user?
      current_user && current_user.admin? ? true : false
    end
    helper_method :admin_user?

    def whitelisted_ip?
      [
        '127.0.0.1',     # local development
        '71.198.81.37',  # The Luton Household
        '99.62.226.166'  # Frontier - frontiervisitor wifi
      ].include? request.remote_ip
    end
    helper_method :whitelisted_ip?

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

    def restrict_to_whitelisted_ips
      not_found unless whitelisted_ip?
    end
end
