#!/usr/bin/env ruby
require 'bundler/setup'
require 'elasticsearch'

CONVERTED_DIR = File.join(File.expand_path('..', __FILE__), 'converted')
INDEX_NAME = 'agenda_with_chapters'

client = Elasticsearch::Client.new hosts: [
  { host: ENV['ELASTICSEARCH_1_PORT_9200_TCP_ADDR'] || 'localhost', port: ENV['ELASTICSEARCH_1_PORT_9200_TCP_PORT'] || 9200 }
]

puts "Deleting index #{INDEX_NAME} from Database"
client.indices.delete index: INDEX_NAME

# https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-api/lib/elasticsearch/api/actions/indices/create.rb#L10
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/mapping-core-types.html
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/index-modules-similarity.html
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis-lang-analyzer.html

client.indices.create index: INDEX_NAME, body: {
  mappings: {
    chapter: {
      properties: {
        party: {
          type: 'string',
          index: 'not_analyzed'
        },
        position: {
          type: 'integer'
        },
        text: {
          type: 'string',
          analyzer: 'german'
        },
        title: {
          type: 'string'
        }
      }
    }
  }
}

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

  puts "Adding #{chapters.size} #{party} chapters to Elasticsearch"

  chapters.each_with_index do |(title, text), i|
    puts "ID #{id} chapter #{i+1}: #{title}"
    client.index index: INDEX_NAME, type: 'chapter', id: id, body: { party: party, position: i+1, title: title, text: text }
    id += 1
  end
end

puts "Done!"

