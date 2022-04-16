require './lib/database/database'
RSpec.describe Database do
    subject(:db) { Database.create } 

    context 'initialization of database' do
      it 'should be a Database' do
        expect(db).to be_a Database
      end
    end

    context 'select all users' do
      it 'should return an array' do
        expect(db.select_all).to be_a Array
      end

    end
    context 'add user' do
      let(:username) { 'luci' }
      let(:password) { 'test' }
      it 'should return true' do
        expect(db.insert_user(username, password)).to be true
      end
    end


  
end