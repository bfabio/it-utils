#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'octokit'

ORGS = %w[teamdigitale italia].freeze
GITHUB_ACCESS_TOKEN = ENV.fetch('GITHUB_ACCESS_TOKEN', '')

abort 'Set GITHUB_ACCESS_TOKEN first.' if GITHUB_ACCESS_TOKEN.empty?

client = Octokit::Client.new(auto_paginate: true, access_token: GITHUB_ACCESS_TOKEN)
client.user.login

ORGS.each do |org|
  client.org_repos(org).each do |repo|
    keys = client.deploy_keys(repo.full_name)
    next if keys.empty?

    puts "#{repo.full_name} (https://github.com/#{repo.full_name}/settings/keys)"
    puts
    keys.each do |key|
      puts "key: #{key.key[0..50]}[...]"
      puts "name: #{key.title}"
      puts
    end
    puts '*' * 80
  end
end
