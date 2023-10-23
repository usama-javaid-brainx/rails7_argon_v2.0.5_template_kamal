# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :null_session
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

      api :POST, "users/register.json", "User Signup"
      error 422, "Unprocessable Entity"
      param_group :user
      returns :user, code: 201

      def create
        super
      end

      private

      def sign_up_params
        params.permit(:email, :password, :first_name, :last_name, :device_token, :app_platform, :app_version)
      end

      def render_create_success
        render_resource(@resource, 201)
      end

      def render_create_error
        render_resource_error(@resource)
      end

    end
  end
end
