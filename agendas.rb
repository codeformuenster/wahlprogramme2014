#!/usr/bin/env ruby
require 'bundler/setup'
require 'elasticsearch'

class AgendaHash

  INDEX_NAME = 'agenda_with_chapters'

  def initialize
    @client = Elasticsearch::Client.new hosts: [
      { host: ENV['ELASTICSEARCH_1_PORT_9200_TCP_ADDR'] || 'localhost', port: ENV['ELASTICSEARCH_1_PORT_9200_TCP_PORT'] || 9200 }
    ]
  end

  def hash
    parties = {}
    @client.search(index: INDEX_NAME, type: 'chapter', sort: 'position', size: 10000)['hits']['hits'].each do |hit|
      result = hit['_source']
      (parties[result['party']] ||= []) << { id: hit['_id'], position: result['position'], title: result['title'], text: result['text'] }
    end
    parties
  end

  def to_json
    hash.to_json
  end
end

hash = AgendaHash.new
puts hash.to_json
