require 'jwt'

class ApplicationController < ActionController::API
    before_action :set_locale
    #protect_from_forgery with: :exception

    around_action :select_shard
    before_action :current_user

    def select_shard(&block)
      # changes shard based on subdomain of host. 
      # if none found, it will use the default shard
      #shard = 'default'.to_sym
      # if request.subdomain.present?
      #   shard = request.subdomain.to_sym
      # end
      # case request.domain
      #   when "www.kingsnefrofleet.com":
      #     shard = :snefro
      # end
      shard = request.host.to_sym
      Octopus.using(shard, &block)
    end

    # def current_site
    #   #@site = Site.first
    #   @site 
    # end

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def current_user
      return @current_user if @current_user
      if auth_present?
        user = User.where( id: auth_user_binary_id ).first
        if user
          @current_user ||= user
          return @current_user
        end
      end
    end

    def auth_user_binary_id
      user_uuid = auth.first["sub"]
      User.id_binary(user_uuid)
    end
    def authenticate
      render json: {error: "unauthorized"}, status: 401 unless logged_in?
    end

    private
    
    def token
      request.env["HTTP_AUTHORIZATION"].to_s.scan(/Bearer (.*)$/).flatten.last
    end
    
    def auth
      JWT.decode(token.to_s, ENV["DEVISE_JWT_SECRET_KEY"].to_s, true) || []
    end
    
    def auth_present?
      !!request.env.fetch("HTTP_AUTHORIZATION", "").to_s.scan(/Bearer/).flatten.first
    end

    # def current_user
    #   return @current_user if @current_user
    #   token = request.headers["Authorization"].to_s.split(" ").last
    #   request.headers.each do |k,v|
    #     $stderr.puts "#{k}" #, request.headers[k]
    #   end
    #   if token
    #     decoded_token = JWT.decode(token, ENV["DEVISE_JWT_SECRET_KEY"], true)
    #     raise decoded_token
    #   end
    # end

    # def get_domain
    #   request_host = request.host
    #   @domain = Domain.where(name: request_host).order(nil).first
    #   # render(:text => "Domain (#{request_host}) is not registered",  :layout => false) and return false if @domain.nil?
    #   raise("Domain (#{request_host}) is not registered") if @domain.nil?
    #   @site = Site.find_by_id(@domain.site_id)
    #   render( :text => 'Site does not exist', :layout => false) and return false if @site.nil?
    #   raise("Site (#{request_host}) does not exist") if @site.nil?
    #   # unless @domain.primary? 
    #   #   primary_domain = @site.primary_domain
    #   #   primary_domain.update_attribute(:primary, 1) if primary_domain.primary.zero?
    #   #   path = "#{primary_domain.full_url}#{request.path}"
    #   #   path += "?#{request.query_string}" unless request.query_string.blank?
    #   #   head :moved_permanently, :location =>  path and return false
    #   # end
    # end

    def render_resource(resource)
      if resource.errors.empty?
        render json: resource, except: [:id]
      else
        validation_error(resource)
      end
    end

    def validation_error(resource)
      render json: {
        errors: [
          {
            status: '400',
            title: 'Bad Request',
            detail: resource.errors,
            code: '100'
          }
        ]
      }, status: :bad_request
    end
end
