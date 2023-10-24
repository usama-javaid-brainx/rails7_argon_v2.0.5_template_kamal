# frozen_string_literal: true

module Api
  module V1
    class PasswordsController < Devise::PasswordsController
      respond_to :json, :html
      protect_from_forgery with: :exception
      include Api::Concerns::ActAsApiRequest


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

      def update
        self.resource = resource_class.reset_password_by_token(resource_params)
        yield resource if block_given?

        if resource.errors.empty?
          resource.unlock_access! if unlockable?(resource)
          sign_in(resource_name, resource) if Devise.sign_in_after_reset_password
          render_resource(resource)
        else
          render json: { error: resource.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      protected

      def after_resetting_password_path_for(_resources)
        api_root_path(notice: flash.notice)
      end

      def resource_params
        params.permit(:password, :password_confirmation, :reset_password_token)
      end
    end
  end
end
