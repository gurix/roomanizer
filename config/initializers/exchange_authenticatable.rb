require 'exchangeable'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class ExchangeAuthenticatable < Authenticatable
      def authenticate!
        return fail(:invalid_login) unless params[:user]
        return fail(:invalid_login) unless authenticated_via_exchange? || authenticated_via_database?
        success!(find_or_create_user)
      end

      def email
        params[:user][:email]
      end

      def password
        params[:user][:password]
      end

      def authenticated_via_exchange?
        Exchangeable.new(Rails.application.secrets.exchange_endpoint, email, password).authenticated?
      end

      def authenticated_via_database?
        User.find_by(email: email)&.valid_password? password
      end

      def find_or_create_user
        user = User.find_or_initialize_by(email: email)
        user.bypass_humanizer = true
        user.from_exchange = true
        user.name = email
        user.password = password unless user.valid_password?(password) # Updates the local password even if the exchange one is different
        user.save
        return user
      end
    end
  end
end

Warden::Strategies.add(:exchange_authenticatable, Devise::Strategies::ExchangeAuthenticatable)
