# encoding: utf-8
require 'bundler/setup'
require 'elasticsearch'

INDEX_NAME = 'agenda_with_chapters'
puts "connected"


party = ARGV[0]
raise "Please give party name as an argument" if party.nil?

client = Elasticsearch::Client.new hosts: [
  { host: ENV['ELASTICSEARCH_1_PORT_9200_TCP_ADDR'], port: ENV['ELASTICSEARCH_1_PORT_9200_TCP_PORT'] }
]

chapters = []
title, text = nil, ''
STDIN.readlines.each do |line|
  if line =~ /\A\s*#+(.+)\Z/
    chapters << [title, text] unless title.nil?

    title = $1.strip
    text = ''
  else
    text << line
  end
end

if client.indices.exists index: INDEX_NAME
  puts "Deleting all #{party} chapters from Elasticsearch"
  client.delete_by_query index: INDEX_NAME, type: 'chapter', body: { party: party }
end

puts "Adding #{chapters.size} chapters to Elasticsearch"

chapters.each_with_index do |(title, text), i|
  puts "chapter #{title}"
  client.index index: INDEX_NAME, type: 'chapter', body: { party: party, position: i+1, title: title, text: text }
end

puts "Done!"

