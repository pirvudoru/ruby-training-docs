require 'sqlite3'

class Database
  PATH = './database.db'
  
  class UserExistsError < StandardError
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
        userId INTEGER,
        token TEXT,
        FOREIGN KEY(userId) REFERENCES Users(id)
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
    pp result
  end

  def insert_user(username, password)
    @db.execute "
    INSERT INTO Users (username, password)
    VALUES (
      '#{username}',
      '#{password}'
    );
    "
    true
    rescue SQLite3::ConstraintException
      raise Database::UserExistsError
  end

  def delete_user
    @db.execute "
    DELETE FROM Users
    "
    rescue StandardError => e
      pp e
  end

  def select_all
    result = @db.execute "
      SELECT * 
      FROM Users
      "
  end
end