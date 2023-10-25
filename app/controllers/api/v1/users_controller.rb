# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApiController
      def_param_group(:user) do
        property :id, Integer
        property :status, String, desc: "Possible values: #{User.statuses.keys}"
        param :first_name, String
        param :last_name, String
        param :email_name, String
        param :app_platform, String, desc: "Possible values: #{User.app_platforms.keys}"
        param :app_version, String
        param :device_token, String
      end

      api :GET, "users/profile.json", "Reader Profile"
      example <<~EOS
        HEADERS: {
          "Content-Type": "application/json",
          "authorization":"Bearer tona5csnjsknkdj788dssndsndjsnd"
        }
      EOS
      returns :user, desc: "a successful response"

      def profile
        render json: current_user
      end

      api :PUT, "users/update.json", "Update user"
      example <<~EOS
        HEADERS: {
          "Content-Type": "application/json",
          "authorization":"Bearer tona5csnjsknkdj788dssndsndjsnd"
        }
      EOS
      param :first_name, String, desc: "First name of user", required: false
      param :last_name, String, desc: "Last name of user", required: false
      param :email, String, desc: "Phone number of user", required: false
      returns :current_user, desc: "a successful response"

      def update
        if current_user.update(user_params)
          render json: current_user
        else
          render_error(422, current_user.errors.full_messages)
        end
      end

      api :PUT, "users/update_password.json", "Change Password"
      example <<~EOS
        HEADERS: {
          "Content-Type": "application/json",
          "authorization":"Bearer tona5csnjsknkdj788dssndsndjsnd"
        }
      EOS
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
        params.permit(:first_name, :last_name, :email, :avatar, :profile_picture_url)
      end

      def password_resource_params
        params.permit(:current_password, :password, :password_confirmation)
      end

    end
  end
end
