# frozen_string_literal: true

require './app/clients/authentication_client'
require 'json'

RSpec.describe AuthenticationClient do
  subject(:authentication) { AuthenticationClient }

  describe '.create_user' do
    subject(:create_user) { authentication.create_user(username, password) }

    let(:username) { 'mr_bean' }
    let(:password) { 'test123' }

    context 'creating a new user' do
      it 'returns an object containing a user token' do
        @result_json = JSON.parse(create_user)
        expect(@result_json['user']['token'].length).to be >= 1
      end
    end

    context 'user already exists' do
      it 'returns an UserAlreadyExistsError' do
        expect { create_user }.to raise_error(UserAlreadyExistsError)
      end
    end
  end

  describe '.delete_user' do
    subject(:delete_user) { authentication.delete_user(username) }

    context 'deleting an existing user' do
      let(:username) { 'mr_bean' }

      it 'returns a true value' do
        expect(delete_user).to be_truthy
      end
    end
  end
end
