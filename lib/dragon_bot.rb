# frozen_string_literal: true

require 'dotenv/load' unless ENV['RUBY_ENV'] == 'production'
require 'discordrb'
require 'active_record'
require './lib/models/weapon'
require './lib/models/accessory'
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

bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_TOKEN'],
                                          prefix: '!'

puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.command :help do |event|
  event << 'Supported commands:'
  event << '!weapon <name>'
  event << '!accessory <name>'
end

bot.command :weapon do |event, *args|
  if args.nil?
    return "Usage: \"!weapon <name>\"\nFor example: \"!weapon Knife +2\""
  end

  input = args.join(' ').downcase
  weapon = Weapon.find_by_name(input)
  return "#{input.capitalize} not found" if weapon.nil?

  event << "**#{input.capitalize}**"
  event << "Required level: #{weapon.level}"
  event << "Classes: #{weapon.classes}"
  event << weapon.stats
  unless weapon.bonus.empty?
    event << 'Bonuses:'
    weapon.bonus.each { |bonus| event << bonus }
  end
  nil
end

bot.command :accessory do |event, *args|
  if args.nil?
    return "Usage: \"!accessory <name>\"\nFor example: \"!weapon Knife +2\""
  end

  input = args.join(' ').downcase
  accessory = Accessory.find_by_name(input)
  return "#{input.capitalize} not found" if accessory.nil?

  event << "**#{input.capitalize}**"
  event << "Required level: #{accessory.level}"
  event << "Classes: #{accessory.classes}"
  event << accessory.stats
  unless accessory.bonus.empty?
    event << 'Bonuses:'
    accessory.bonus.each { |bonus| event << bonus }
  end
  nil
end

bot.run
