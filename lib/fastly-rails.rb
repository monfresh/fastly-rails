require 'fastly-rails/engine'
require 'fastly-rails/client'
require 'fastly-rails/configuration'
require 'fastly-rails/errors'

module FastlyRails
  attr_reader :client, :configuration

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end

  def self.customer_key
    fail NoServiceIdProvidedError if configuration.invalid_customer_key?
    configuration.customer_key
  end

  def self.client
    fail NoAPIKeyProvidedError unless configuration.authenticatable?

    @client ||= Client.new(
      api_key: configuration.api_key,
      user: configuration.user,
      password: configuration.password
    )
  end
end
