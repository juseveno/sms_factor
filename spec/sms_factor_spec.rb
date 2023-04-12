# frozen_string_literal: true

require 'spec_helper'

describe SmsFactor, vcr: true do
  describe 'sms' do
    let(:message) { FFaker::LoremFR.phrase[0..160] }
    let(:recipients) { FFaker::PhoneNumberFR.mobile_phone_number }

    context 'without being configured' do
      it 'raises' do
        expect { described_class.sms(message, recipients) }
          .to raise_error(RuntimeError, /The configuration is not complete\./)
      end
    end

    context 'with wrong credentials auth' do
      let(:cassette_name) { 'wrong_credentials_auth' }

      before do
        SmsFactor::Init.configure do |config|
          config.api_default_from = FFaker::CompanyFR.name
          config.api_login = FFaker::Internet.email
          config.api_password = FFaker::Internet.password
        end
      end

      it "doesn't deliver" do
        expect(described_class.sms(message, recipients)).not_to be_success
      end
    end

    context 'with valid credentials auth' do
      let(:cassette_name) { 'valid_credentials_auth' }

      before do
        SmsFactor::Init.configure do |config|
          config.api_default_from = FFaker::CompanyFR.name
          config.api_login = 'juseveno@idol.io'
          config.api_password = 'julien'
        end
      end

      it 'delivers' do
        expect(described_class.sms(message, '0799175425')).to be_success
      end

      it 'responds with status equal 1' do
        expect(described_class.sms(message, '0799175425').status).to be 1
      end

      it 'responds with message equal to "OK"' do
        expect(described_class.sms(message, '0799175425').message).to eql 'OK'
      end
    end

    context 'with wrong API key auth' do
      let(:cassette_name) { 'wrong_api_key_auth' }

      before do
        SmsFactor::Init.configure do |config|
          config.api_default_from = FFaker::CompanyFR.name
          config.api_key = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiw' \
                           'iaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'
        end
      end

      it "doesn't deliver" do
        expect(described_class.sms(message, recipients)).not_to be_success
      end

      it 'responds with status equal -1' do
        expect(described_class.sms(message, '0799175425').status).to be(-1)
      end
    end

    context 'with valid API key auth' do
      let(:cassette_name) { 'valid_api_key_auth' }

      before do
        SmsFactor::Init.configure do |config|
          config.api_default_from = FFaker::CompanyFR.name
          config.api_key = SMS_FACTOR_API_KEY
        end
      end

      it 'delivers' do
        expect(described_class.sms(message, '0799175425')).to be_success
      end

      it 'responds with status equal 1' do
        expect(described_class.sms(message, '0799175425').status).to be 1
      end

      it 'responds with message equal to "OK"' do
        expect(described_class.sms(message, '0799175425').message).to eql 'OK'
      end
    end
  end
end
