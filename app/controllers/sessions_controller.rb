class SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { user: { username: resource.email, token: current_token , image: ""}}
  end

  def respond_to_on_destroy
    head :no_content
  end

def current_token
    request.env['warden-jwt_auth.token']
  end
end
