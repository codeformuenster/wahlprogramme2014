#!/usr/bin/env ruby
require 'bundler/setup'
require 'elasticsearch'

class DistanceMatrix

  INDEX_NAME = 'agenda_with_chapters'

  def initialize
    @client = Elasticsearch::Client.new hosts: [
      { host: ENV['ELASTICSEARCH_1_PORT_9200_TCP_ADDR'] || 'localhost', port: ENV['ELASTICSEARCH_1_PORT_9200_TCP_PORT'] || 9200 }
    ]
  end

  def query_mlt(chapter_id)
    @client.mlt index: INDEX_NAME, type: 'chapter', id: chapter_id, mlt_fields: 'text', search_size: 10000
  end

  def distance_score_for_chapter(id)
    distance_entries = [] 
    chapters = query_mlt(id)["hits"]["hits"]
    chapters.each do |chapter|
      distance_entry = [id, chapter["_id"].to_i, chapter["_score"].to_f]
      distance_entries << distance_entry
    end
    distance_entries
  end

  def all_distance_scores
    all_distance_scores = []
    @client.count["count"].times do |chapter_id|
      all_distance_scores << distance_score_for_chapter(chapter_id+1)
    end
    all_distance_scores.flatten 1
  end
end

dm = DistanceMatrix.new
puts dm.all_distance_scores.to_json
