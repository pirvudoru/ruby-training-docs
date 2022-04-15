# frozen_string_literal: true

require './app/errors/user_already_exists_error'
require './app/errors/incorrect_user_credentials_error'
require 'sqlite3'
require 'securerandom'

class DBClient
  def self.create
    @instance ||= new
  end

  def initialize
    @db = SQLite3::Database.open 'USERS.db'
    @db.execute 'CREATE TABLE IF NOT EXISTS users(username TEXT PRIMARY KEY, password TEXT)'
    @db.execute 'CREATE TABLE IF NOT EXISTS tokens(token VARCHAR(32) PRIMARY KEY, username TEXT)'
  end

  def create_user(username, password)
    begin
      add_user(username, password)
    rescue SQLite3::ConstraintException
      raise UserAlreadyExistsError.new
    else
      token = generate_token
      add_token(username, token)
      token
    end
  end

  def delete_user(username)
    @db = SQLite3::Database.open 'USERS.db'
    @db.execute 'DELETE FROM users WHERE username=?', username.to_s
    @db.execute 'DELETE FROM tokens WHERE username=?', username.to_s
  ensure
    @db.close
  end

  def login_user(username, password)
    raise IncorrectUserCredentialsError.new unless validate_password(username, password)
    token = generate_token
    add_token(username, token)
    token
  end

  private

  def add_user(username, password)
    @db = SQLite3::Database.open 'USERS.db'
    @db.execute 'INSERT INTO users (username, password) VALUES (?, ?)',
                username.to_s, password.to_s
  ensure
    @db.close
  end

  def add_token(username, token)
    @db = SQLite3::Database.open 'USERS.db'
    @db.execute 'INSERT INTO tokens (token, username) VALUES (?, ?)',
                token.to_s, username.to_s
  ensure
    @db.close
  end

  def validate_password(username, password)
    @db = SQLite3::Database.open 'USERS.db'
    results = @db.query 'SELECT password FROM users WHERE username=?', username.to_s
    first_result = results.next
    first_result[0].eql? password if first_result
  ensure
    results.close
    @db.close
  end

  def generate_token
    SecureRandom.hex(16)
  end
end
