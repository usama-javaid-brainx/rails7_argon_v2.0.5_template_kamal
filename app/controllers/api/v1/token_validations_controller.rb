# frozen_string_literal: true

module Api
  module V1
    class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
      protect_from_forgery with: :null_session
      include Api::Concerns::ActAsApiRequest

      api :GET, "users/validate_token.json", "User token validations"

      def validate_token
        super
      end
    end
  end
end
