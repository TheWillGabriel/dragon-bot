# frozen_string_literal: true

require 'dotenv/load' unless ENV['RUBY_ENV'] == 'production'
require 'slack-ruby-bot'
require './lib/models/weapon'
require './lib/models/accessory'
require './lib/helpers/format'

SlackRubyBot::Client.logger.level = Logger::WARN

class SlackBot < SlackRubyBot::Bot
  help do
    title 'Dragon Bot'
    desc 'Item helper for Dragon Marked For Death'

    command '!weapon <name>' do
      desc 'Lists the stats for the given weapon'
    end

    command '!accessory <name>' do
      desc 'Lists the stats for the given accessory'
    end
  end

  operator '!weapon ' do |client, data, match|
    input = match[:expression]
    weapon = Weapon.find_by_name(input)

    if weapon.nil?
      client.say(channel: data.channel,
                 text: "#{Format.title(input)} not found")
    else
      response = Format.equip_info(weapon)
                       .join("\n")
                       .gsub('**', '*')
      client.say(channel: data.channel, text: response)
    end
  end

  operator '!accessory ' do |client, data, match|
    input = match[:expression]
    accessory = Accessory.find_by_name(input)

    if accessory.nil?
      client.say(channel: data.channel,
                 text: "#{Format.title(input)} not found")
    else
      response = Format.equip_info(accessory)
                       .join("\n")
                       .gsub('**', '*')
      client.say(channel: data.channel, text: response)
    end
  end
end
