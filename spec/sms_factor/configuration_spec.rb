# frozen_string_literal: true

require 'spec_helper'

describe SmsFactor::Configuration do
  describe '#api_auth?' do
    let(:configuration) { described_class.new }

    context 'when using all default values' do
      it 'is falsy' do
        expect(configuration).not_to be_api_auth
      end
    end

    context 'with a default from' do
      let(:configuration) do
        configuration = described_class.new
        configuration.api_default_from = 'Toto'
        configuration
      end

      it 'is falsy' do
        expect(configuration).not_to be_api_auth
      end

      context 'with Email / password authentication configuration' do
        let(:configuration_with_auth) do
          configuration.api_login = 'guillaume.briat@kaamelott.fr'
          configuration.api_password = 'Pas changer assiette pour fromage!'
          configuration
        end

        it 'is falsy' do
          expect(configuration_with_auth).not_to be_api_auth
        end
      end

      context 'with API key authentication configuration' do
        let(:configuration_with_auth) do
          configuration.api_key = SMS_FACTOR_API_KEY
          configuration
        end

        it 'is truthy' do
          expect(configuration_with_auth).to be_api_auth
        end
      end

      context 'with both Email / password and API key authentication configuration' do
        let(:configuration_with_auth) do
          configuration.api_login = 'guillaume.briat@kaamelott.fr'
          configuration.api_password = 'Pas changer assiette pour fromage!'
          configuration.api_key = SMS_FACTOR_API_KEY
          configuration
        end

        it 'is truthy' do
          expect(configuration_with_auth).to be_api_auth
        end
      end
    end
  end

  describe '#invalid?' do
    let(:configuration) { described_class.new }

    context 'when using all default values' do
      it 'is invalid' do
        expect(configuration).to be_invalid
      end
    end

    context 'with a default from' do
      let(:configuration) do
        configuration = described_class.new
        configuration.api_default_from = 'Toto'
        configuration
      end

      it 'is invalid' do
        expect(configuration).to be_invalid
      end

      context 'with Email / password authentication configuration' do
        let(:configuration_with_auth) do
          configuration.api_login = 'guillaume.briat@kaamelott.fr'
          configuration.api_password = 'Pas changer assiette pour fromage!'
          configuration
        end

        it 'is valid' do
          expect(configuration_with_auth).not_to be_invalid
        end
      end

      context 'with API key authentication configuration' do
        let(:configuration_with_auth) do
          configuration.api_key = SMS_FACTOR_API_KEY
          configuration
        end

        it 'is valid' do
          expect(configuration_with_auth).not_to be_invalid
        end
      end

      context 'with both Email / password and API key authentication configuration' do
        let(:configuration_with_auth) do
          configuration.api_login = 'guillaume.briat@kaamelott.fr'
          configuration.api_password = 'Pas changer assiette pour fromage!'
          configuration.api_key = SMS_FACTOR_API_KEY
          configuration
        end

        it 'is valid' do
          expect(configuration_with_auth).not_to be_invalid
        end
      end
    end
  end
end
