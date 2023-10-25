# frozen_string_literal: true

module Api
  module V1
    class PasswordsController < Devise::PasswordsController
      respond_to :json, :html
      protect_from_forgery with: :exception
      include Api::Concerns::ActAsApiRequest

      def_param_group(:user) do
        property :id, Integer
        param :status, String, desc: "Possible values: #{User.statuses.keys}"
        param :first_name, String, required: true
        param :last_name, String, required: true
        param :app_platform, String, desc: "Possible values: #{User.app_platforms.keys}", required: true
        param :app_version, String, required: true
        param :device_token, String
        param :email, String, required: true
        param :password, String, required: true
      end

      api :POST, "users/password.json", "Reader Reset Password"
      error 422, "Unprocessable Entity"
      description "Authorization not required"
      param :email, String, required: true
      returns code: 200, desc: "a successful response" do
        property :message, String
      end
      # this action is responsible for generating password reset tokens and sending emails

      def create
        self.resource = resource_class.send_reset_password_instructions(email: params[:email])
        yield resource if block_given?
        if successfully_sent?(resource)
          render_resource({ message: I18n.t("devise.passwords.sended", email: params[:email]) }, 200)
        else
          render_error(422, resource.errors.full_messages.join(", "))
        end
      end

      api :PUT, "users/register.json", "User Signup"
      example <<~EOS
        HEADERS: {
          "Content-Type": "application/json",
          "app-platform":"react"
          "app-version": "1"
        }
      EOS
      error 422, "Unprocessable Entity"
      param_group :user
      returns :user, code: 200

      def update
        self.resource = resource_class.reset_password_by_token(resource_params)
        yield resource if block_given?

        if resource.errors.empty?
          resource.unlock_access! if unlockable?(resource)
          if Devise.sign_in_after_reset_password
            generate_new_authorization_token # comment this if you dont want to auto sign in
          end
          render_resource(resource)
        else
          render json: { error: resource.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      protected

      def after_resetting_password_path_for(_resources)
        api_root_path(notice: flash.notice) # change this method according to your requirement
      end

      def resource_params
        params.permit(:password, :password_confirmation, :reset_password_token)
      end

      def generate_new_authorization_token
        access_token_hash = resource.create_new_auth_token
        response.headers['access-token'] = access_token_hash['access-token']
        response.headers['uid'] = access_token_hash['uid']
        response.headers['client'] = access_token_hash['client']
        response.headers['expiry'] = access_token_hash['expiry']
        response.headers['token-type'] = access_token_hash['token-type']
        response.headers['authorization'] = access_token_hash['authorization']
      end
    end
  end
end
