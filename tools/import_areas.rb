#!/usr/bin/env ruby
# coding: utf-8

require 'json'

require 'rubygems'
require 'bundler/setup'
require 'leveldb'

if ARGV.size != 2
  puts "usage #$0 [iarea_def.js] [dest_lebeldb_file]"
  exit -1
end

src_path = ARGV.shift
dest_path = ARGV.shift

db = LevelDB::DB.new dest_path

js = open(src_path, "r:cp932").read
js.sub!(%r|^var IAreaDef=new function\(\)\{|, "")
data = {}
js.scan %r|this\.(.+?)=(.+?);|m do |key, json|
  data[key] = JSON.parse(json)
end
# zones
data['zones'].each_with_index do |zone, i|
  id = i + 1
  $stderr.puts "  importing zone %d %s" % [id, zone['name']]
  areacodes = data['areas'].select {|areacode, area| area['zone'] == i}.keys
  prefecture_ids = data['prefs'].each.with_index.select {|pref, j| pref['zone'] == i}.map{|pref, j| j+1 }

  db['z:%d' % id] = JSON.dump(
    :id => id,
    :name => zone['name'],
    :areacodes => areacodes,
    :prefecture_ids => prefecture_ids
  )
end

db['z'] = JSON.dump(data['zones'].map.with_index{|z, i| i + 1})

# prefs
data['prefs'].each_with_index do |pref, i|
  id = i + 1
  $stderr.puts "  importing prefecture %d %s" % [id, pref['name']]
  areacodes = data['areas'].select {|areacode, area| area['pref'] == i}.keys
  db['p:%d' % id] = JSON.dump(
    :id => id,
    :name => pref['name'],
    :zone_id => pref['zone'] + 1,
    :areacodes => areacodes
  )
end
db['p'] = JSON.dump(data['prefs'].map.with_index{|z, i| i + 1})

# areas
data['areas'].each do |areacode, area|
  $stderr.puts "  importing area %s %s" % [areacode, area['name']]
  # insert area
  hash = {
    :areaid => areacode[0..2],
    :subareaid => areacode[3..4],
    :areacode => areacode,
    :name => area['name'],
    :west => area['msWest'],
    :south => area['msSouth'],
    :east => area['msEast'],
    :north => area['msNorth'],
    :zone_id => area['zone'] + 1,
    :prefecture_id => area['pref'] + 1
  }
  # fix .js problem
  if hash[:name] == '新宿１?２丁目'
    hash[:name] = '新宿１〜２丁目'
  end
  db['a:%s' % areacode] = JSON.dump(hash)
  db['n:%s' % areacode] = JSON.dump(area['neighbors'])
end
