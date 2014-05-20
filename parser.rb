#!/usr/bin/env ruby
require 'bundler/setup'
require 'elasticsearch'

CONVERTED_DIR = File.join(File.expand_path('..', __FILE__), 'converted')
INDEX_NAME = 'agenda_with_chapters'

client = Elasticsearch::Client.new hosts: [
  { host: ENV['ELASTICSEARCH_1_PORT_9200_TCP_ADDR'] || 'localhost', port: ENV['ELASTICSEARCH_1_PORT_9200_TCP_PORT'] || 9200 }
]

id = 1
Dir.foreach(CONVERTED_DIR) do |file|
  next if file[0] == '.'

  party = File.basename(file, '.md')
  puts "Party: #{party}"

  chapters = []
  title, text = nil, ''
  File.readlines(File.join(CONVERTED_DIR, file)).each do |line|
    if line =~ /^##[^#](.+)/
      chapters << [title, text] unless title.nil?

      title = $1.strip
      text = ''
    else
      text << line
    end
  end

  if client.indices.exists index: INDEX_NAME
    puts "Deleting all #{party} chapters from Elasticsearch"
    client.delete_by_query index: INDEX_NAME, type: 'chapter', q: "party:#{party}"
  end

  puts "Adding #{chapters.size} #{party} chapters to Elasticsearch"

  chapters.each_with_index do |(title, text), i|
    puts "ID #{id} chapter #{i+1}: #{title}"
    client.index index: INDEX_NAME, type: 'chapter', id: id, body: { party: party, position: i+1, title: title, text: text }
    id += 1
  end
end

puts "Done!"

