require 'rails_helper'
require 'exchangeable'

describe 'Exchangeable' do
  let(:unathorized_response_error) { Viewpoint::EWS::Errors::UnauthorizedResponseError.new('Unauthorized', status: 401, body: 'Unauthorized') }
  describe '#authenicated?' do
    it 'authenticates' do
      exchangeable = Exchangeable.new('https://example.com/EWS/Exchange.asmx', 'username', 'password')

      expect(exchangeable.instance_variable_get(:@client)).to receive(:folders).and_return([1, 2, 3])

      expect(exchangeable.authenticated?).to be true

      expect(exchangeable.instance_variable_get(:@client)).to receive(:folders).and_raise(unathorized_response_error)

      expect(exchangeable.authenticated?).to be false
    end
  end
end
