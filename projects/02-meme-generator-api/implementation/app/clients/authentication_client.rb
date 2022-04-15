# frozen_string_literal: true

require './app/clients/db_client'

class AuthenticationClient
  class << self
    def create_user(username, password)
      @db_client = DBClient.new
      token = @db_client.create_user(username, password)

      result = { "user": { "token": token.to_s } }
      result.to_json
    end

    def delete_user(username)
      @db_client = DBClient.new
      @db_client.delete_user(username)
    end

    def login_user(username, password)
      @db_client = DBClient.new
      token = @db_client.login_user(username, password)

      result = { "user": { "token": token.to_s } }
      result.to_json
    end

    def validate_user(token)
      @db_client = DBClient.new
      @db_client.validate_user(token)
    end
  end
end
