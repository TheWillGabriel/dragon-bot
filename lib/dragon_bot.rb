# frozen_string_literal: true

require 'dotenv/load' unless ENV['RUBY_ENV'] == 'production'
require 'active_record'
require './lib/bots/discord'
require 'erb'

def db_configuration
  db_configuration_file = File.join(File.expand_path(__dir__),
                                    '..',
                                    'db',
                                    'config.yml')
  YAML.safe_load(ERB.new(File.read(db_configuration_file)).result,
                 aliases: true)
end

ActiveRecord::Base.establish_connection(db_configuration[ENV['RUBY_ENV']])

DiscordBot.new token: ENV['DISCORD_TOKEN'], prefix: '!'
