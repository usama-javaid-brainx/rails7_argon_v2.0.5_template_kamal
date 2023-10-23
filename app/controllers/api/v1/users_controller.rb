# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApiController
      def_param_group(:current_user) do
        property :id, Integer
        property :active?, [true, false]
        param :name, String, required: true
        param :app_platform, String, desc: "Possible values: #{User.app_platforms.keys}", required: true
        param :app_version, String, required: true
        param :device_token, String
      end

      api :GET, "users/profile.json", "Reader Profile"
      returns :current_user, desc: "a successful response"

      def profile
        render json: current_user, adapter: :json
      end

      api :PUT, "users/update", "Update user"
      param :username, String, desc: "Username of user", required: false
      param :email, String, desc: "Email of user", required: false
      param :phone_number, String, desc: "Phone number of user", required: false
      returns :current_user, desc: "a successful response"

      def update
        if current_user.update(user_params)
          render json: current_user, adapter: :json
        else
          render_error(422, current_user.errors.full_messages)
        end
      end

      api :PUT, "user/change_password.json", "Change Password"
      param :current_password, String, required: true
      param :password, String, required: true
      param :password_confirmation, String, required: true
      returns code: 200, desc: "a successful response" do
        property :message, String
      end

      def update_password
        if params[:password] != params[:password_confirmation]
          render_error(422, I18n.t("devise.passwords.mismatch"))
        elsif current_user.update_with_password(password_resource_params) && current_user.save
          render_message(I18n.t("devise.passwords.updated"))
        else
          render_error(422, current_user.errors.full_messages)
        end
      end

      private

      def user_params
        params.permit(:first_name, :last_name, :email, :avatar, :phone_number)
      end

      def password_resource_params
        params.permit(:current_password, :password, :password_confirmation)
      end

    end
  end
end
