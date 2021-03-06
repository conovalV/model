require_relative 'abstract'
require 'hanami/utils/blank'
require 'pathname'
require 'stringio'

module Database
  module Strategies
    class Sql < Abstract
      def self.eligible?(_adapter)
        false
      end

      protected

      def before
        super
        logger.unlink if logger.exist?
        logger.dirname.mkpath
      end

      def export_env
        super
        ENV['HANAMI_DATABASE_ADAPTER'] = 'sql'
        ENV['HANAMI_DATABASE_LOGGER'] = logger.to_s
      end

      def configure # rubocop:disable Metrics/AbcSize
        Hanami::Model.configure do
          adapter    ENV['HANAMI_DATABASE_ADAPTER'].to_sym, ENV['HANAMI_DATABASE_URL']
          logger     ENV['HANAMI_DATABASE_LOGGER'], level: :debug
          migrations Dir.pwd + '/spec/support/fixtures/database_migrations'
          schema     Dir.pwd + '/tmp/schema.sql'

          migrations_logger ENV['HANAMI_DATABASE_LOGGER']

          gateway do |g|
            g.connection.extension(:pg_enum) if Database.engine?(:postgresql)
          end
        end
      end

      def after
        migrate
        puts "Testing with `#{ENV['HANAMI_DATABASE_ADAPTER']}' adapter (#{ENV['HANAMI_DATABASE_TYPE']}) - jruby: #{jruby?}, ci: #{ci?}"
        puts "Env: #{ENV.inspect}" if ci?
      end

      def migrate
        TestIO.with_stdout do
          require 'hanami/model/migrator'
          Hanami::Model::Migrator.migrate
        end
      end

      def credentials
        [ENV['HANAMI_DATABASE_USERNAME'], ENV['HANAMI_DATABASE_PASSWORD']].reject do |token|
          Hanami::Utils::Blank.blank?(token)
        end.join(':')
      end

      def host
        ENV['HANAMI_DATABASE_HOST'] || 'localhost'
      end

      def host_and_credentials
        result = [host]
        result.unshift(credentials) unless Hanami::Utils::Blank.blank?(credentials)
        result.join("@")
      end

      def logger
        Pathname.new('tmp').join('hanami_model.log')
      end
    end
  end
end
