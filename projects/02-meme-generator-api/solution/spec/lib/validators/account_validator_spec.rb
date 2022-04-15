require './lib/validators/account_validator'

RSpec.describe AccountValidator do
  describe '.validate_account' do
    context 'validate request body for account' do
      let(:body) { JSON.parse('{
        "user": {
          "username": "mr_bean",
          "password": "test123"
        }
      }')
    }
      subject(:account_validation) { AccountValidator.validate_account(body) }

      it 'with good body request' do
        expect(account_validation).to eq ['mr_bean', 'test123']
      end
  
    end
    context 'with password empty body parameter' do
      let(:body) { JSON.parse('{
        "user": {
          "username": "mr_bean",
          "password": ""
        }
      }') }
      subject(:account_validation) { AccountValidator.validate_account(body) }

      it 'raises password empty error' do
        expect{ account_validation }.to raise_error(AccountValidator::EmptyParameterError,'Password is blank')
      end
    end

    context 'with username empty body parameter' do
      let(:body) { JSON.parse('{
        "user": {
          "username": "",
          "password": "213215"
        }
      }') }
      subject(:account_validation) { AccountValidator.validate_account(body) }

      it 'raises username empty error' do
        expect{ account_validation }.to raise_error(AccountValidator::EmptyParameterError,'Username is blank')
      end
    end
  end
end
