#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'skype'

chats = Skype.chats
puts "#{chats.length} chats found"
chats.each_with_index do |c, index|
  title = "#{c.topic} #{c.members[0..5].join(',')} (#{c.members.size} users)".strip
  puts "[#{index}] #{title}"
end

chat = nil
loop do
  print "select [0]~[#{chats.size-1}] >"
  line = STDIN.gets.strip
  next unless line =~ /^\d+$/
  chat = chats[line.to_i]
  break
end

Thread.new do
  last_id = 0
  loop do
    chat.messages.each do |m|
      next unless last_id < m.id
      puts m
      last_id = m.id
    end
    sleep 1
  end
end

loop do
  line = STDIN.gets.strip
  chat.post line
end
