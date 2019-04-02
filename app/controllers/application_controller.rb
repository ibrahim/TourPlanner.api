class ApplicationController < ActionController::API
    before_action :set_locale
    #protect_from_forgery with: :exception


    around_action :select_shard
    # before_action :get_domain

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
        render json: resource
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
