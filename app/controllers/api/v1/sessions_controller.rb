# frozen_string_literal: true

module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      include Api::Concerns::ActAsApiRequest

      def_param_group(:user) do
        property :id, Integer
        param :status, String, desc: "Possible values: #{User.statuses.keys}"
        param :first_name, String, required: true
        param :last_name, String, required: true
        param :username, String, required: true
        param :email, String, required: true
        param :device_token, String
        param :app_version, String, required: true
      end

      api :POST, "users/login.json", "User login"
      example <<~EOS
        HEADERS: {
          "Content-Type": "application/json",
          "app-platform":"react"
          "app-version": "1"
        }
      EOS
      error 422, "Unprocessable Entity"
      description "Authorization not required, It will return access-token, client, uid in header, which required for authorization"
      param :email, String, required: true
      param :password, String, required: true
      param :device_token, String, required: true
      param :app_version, String, required: true

      returns :user, code: 201, desc: "a successful response"

      def create
        super do
          @resource.update(resource_update_params)
        end
      end

      api :Delete, "users/logout.json", "User logout"
      example <<~EOS
        HEADERS: {
          "Content-Type": "application/json",
          "authorization":"Bearer tona5csnjsknkdj788dssndsndjsnd"
        }
      EOS
      def destroy
        # remove auth instance variables so that after_action does not run
        user = @resource ? remove_instance_variable(:@resource) : nil
        client = @token.client
        @token.clear!

        if user
          user.tokens.delete(client) if client && user.tokens[client]
          user.update(device_token: "")
          render_message("User signed out successfully ", status = 200)
        else
          render_destroy_error
        end
      end

      protected

      def render_create_success
        render_resource(@resource)
      end

      def render_create_error_bad_credentials
        render_error(422, I18n.t("devise_token_auth.sessions.bad_credentials"))
      end

      def render_create_error_account_locked
        if @resource.active_for_authentication?
          render_error(401, I18n.t("devise.mailer.unlock_instructions.account_lock_msg"))
        else
          render_create_error_not_confirmed
        end
      end

      def render_create_error_not_confirmed
        render_error(401, I18n.t("devise.failure.#{@resource.inactive_message}"))
      end

      def render_destroy_error
        render_error(422, I18n.t("devise_token_auth.sessions.user_not_found"))
      end

      private

      def resource_params
        params.permit(:email, :password)
      end

      def resource_update_params
        params.permit(:device_token).merge(app_platform: request.headers["app-platform"], app_version: request.headers["app-version"])
      end
    end
  end
end
