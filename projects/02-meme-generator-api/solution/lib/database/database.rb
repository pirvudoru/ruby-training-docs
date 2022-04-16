require 'sqlite3'
require 'pry'

class Database
  PATH = './database.db'
  
  class UserExistsError < StandardError
  end
  
  class NonExistentUserError < StandardError
  end

  class << self
    def create()
      @instance ||= new
    end
  end


  def initialize
    @db = SQLite3::Database.new(PATH)
    @db.execute "CREATE TABLE IF NOT EXISTS Users(
      id INTEGER PRIMARY KEY,
      username TEXT,
      password TEXT,
      unique(username))
    "
    @db.execute "
      CREATE TABLE IF NOT EXISTS UsersTokens (
        id INTEGER PRIMARY KEY,
        username TEXT,
        token TEXT
      )
    "
    @db.results_as_hash = true
  end

  def get_user(username)
    result = @db.execute "
      SELECT * 
      FROM Users
      WHERE username = '#{username}';
    "
    raise Database::NonExistentUserError.new('This username does not exist.') unless result.first
    result.first
  end

  def get_tokens(username)
    result = @db.execute "
      SELECT * 
      FROM UsersTokens
      WHERE username = '#{username}';
    "
    result.first
  end

  def insert_user(user)
    @db.execute "
    INSERT INTO Users (username, password)
    VALUES (
      '#{user.username}',
      '#{user.password}'
    );
    "
    true
    rescue SQLite3::ConstraintException
      raise Database::UserExistsError.new('Username already exists')
  end

  def insert_token(user_token)
    @db.execute "
      INSERT INTO UsersTokens (username, token)
      VALUES (
        '#{user_token.user.username}',
        '#{user_token.value}'
      );
    "
  end
  def truncate
    @db.execute "
    DELETE FROM Users
    "
    @db.execute "
    DELETE FROM UsersTokens
    "
  end

  def select_all
    result = @db.execute "
      SELECT * 
      FROM Users
      "
  end
end