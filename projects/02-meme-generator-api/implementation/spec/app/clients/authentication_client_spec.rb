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

  describe '.login_user' do
    subject(:login_user) { authentication.login_user(username, password) }

    context 'logging in a user' do
      let(:username) { 'mr_bean' }
      let(:password) { 'test123' }

      it 'returns an object containing a user token' do
        @result_json = JSON.parse(login_user)
        expect(@result_json['user']['token'].length).to be >= 1
      end
    end

    context 'giving unknown user' do
      let(:username) { 'cat' }
      let(:password) { 'test123' }

      it 'returns an IncorrectUserCredentialsError' do
        expect { login_user }.to raise_error(IncorrectUserCredentialsError)
      end
    end

    context 'giving incorrect password' do
      let(:username) { 'mr_bean' }
      let(:password) { 'testcat' }

      it 'returns an IncorrectUserCredentialsError' do
        expect { login_user }.to raise_error(IncorrectUserCredentialsError)
      end
    end
  end

  describe '.validate_user' do
    subject(:validate_user) { authentication.validate_user(token) }

    let(:username) { 'mr_bean' }
    let(:password) { 'test123' }

    context 'giving an existent token' do
      let(:token) { JSON.parse(authentication.login_user(username, password))['user']['token'] }

      it 'returns a true value' do
        expect(validate_user).to be_truthy
      end
    end

    context 'giving an invalid token' do
      let(:token) { '9411a3b57f420dc9c09a25bd78ae2851' }
      it 'returns a false value' do
        expect(validate_user).to be_falsey
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
