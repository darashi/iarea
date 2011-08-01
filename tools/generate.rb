#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'json'

require 'rubygems'
require 'bundler/setup'
require 'msgpack'

def import_meshes(src_path)
  mesh_to_iarea_hash = {}
  Dir[File.join(src_path, "iareadata/iarea*.txt")].each do |path|
    data = CSV.open(path, "r:cp932")
    data.each do |row|
      areaid, subareaid, name, west, south, east, north, *mesh_data = row
      areacode = areaid + subareaid

      name.encode!("UTF-8")

      mesh_data.pop if mesh_data.last.nil?
      $stderr.puts "  importing meshes %s %s" % [areacode, name]
      num_meshes = mesh_data.shift(7).map(&:to_i)

      expected_num_meshes = num_meshes.inject(&:+)
      if expected_num_meshes != mesh_data.size
        raise "number of meshes mismatch: expected %d, actual %d" % [
          expected_num_meshes, mesh_data.size
        ]
      end

      # insert meshes
      mesh_data.each do |mesh|
        mesh_to_iarea_hash[mesh] = areacode
      end
    end
  end
  mesh_to_iarea_hash
end

def import_metadata(src_path)
  js = open(src_path, "r:cp932").read
  js.sub!(%r|^var IAreaDef=new function\(\)\{|, "")
  data = {}
  js.scan %r|this\.(.+?)=(.+?);|m do |key, json|
    data[key] = JSON.parse(json)
  end

  db = Hash.new{|h,k| h[k] = {}}

  # zones
  data['zones'].each_with_index do |zone, i|
    id = i + 1
    $stderr.puts "  importing zone %d %s" % [id, zone['name']]
    areacodes = data['areas'].select {|areacode, area| area['zone'] == i}.keys
    prefecture_ids = data['prefs'].each.with_index.select {|pref, j| pref['zone'] == i}.map{|pref, j| j+1 }

    db['zone'][id] = {
      :id => id,
      :name => zone['name'],
      :areacodes => areacodes,
      :prefecture_ids => prefecture_ids
    }
  end

  db['zone_ids'] = data['zones'].map.with_index{|z, i| i + 1}

  # prefs
  data['prefs'].each_with_index do |pref, i|
    id = i + 1
    $stderr.puts "  importing prefecture %d %s" % [id, pref['name']]
    areacodes = data['areas'].select {|areacode, area| area['pref'] == i}.keys
    db['prefecture'][id] = {
      :id => id,
      :name => pref['name'],
      :zone_id => pref['zone'] + 1,
      :areacodes => areacodes
    }
  end
  db['prefecture_ids'] = data['prefs'].map.with_index{|z, i| i + 1}

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
      :prefecture_id => area['pref'] + 1,
      :neighbors => area['neighbors']
    }
    # fix .js problem
    if hash[:name] == '新宿１?２丁目'
      hash[:name] = '新宿１〜２丁目'
    end
    db['area'][areacode] = hash
  end
  db
end


db_dir = ARGV.shift
js_path = ARGV.shift
iareadata_dir = ARGV.shift

meta = import_metadata(js_path)
File.open(File.join(db_dir, 'meta.msgpack'), 'w') do |f|
  f.write meta.to_msgpack
end

mesh_to_iarea_hash = import_meshes(iareadata_dir)
File.open(File.join(db_dir, 'mesh.msgpack'), 'w') do |f|
  f.write mesh_to_iarea_hash.to_msgpack
end

