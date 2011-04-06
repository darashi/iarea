require 'sequel'
require 'ostruct'

module Iarea
  DB = Sequel.sqlite(File.expand_path("../../db/iareadata.sqlite3", __FILE__))

  class Area < OpenStruct
    @@areas = {}
    def prefecture
      Prefecture.find(self.prefecture_id)
    end

    def zone
      Zone.find(self.zone_id)
    end

    class << self
      def find(areacode)
        @@areas[areacode] ||= new DB[:areas].where(:areacode => areacode).first
      end

      def find_by_lat_lng(lat, lng)
        meshcodes = Utils.expand_meshcode(Utils.lat_lng_to_meshcode(lat, lng))
        area = DB[:meshes].where(:meshcode => meshcodes).select(:areacode).first
        return nil if area.nil?
        find(area[:areacode])
      end
    end
  end

  class Zone < OpenStruct
    @@zones = []

    def prefectures
      DB[:prefectures].where(:zone_id => self.id).select(:id).order(:id).map do |prefecture|
        Prefecture.find(prefecture[:id])
      end
    end

    def areas
      DB[:areas].where(:zone_id => self.id).select(:areacode).order(:areacode).map do |area|
        Area.find(area[:areacode])
      end
    end

    class << self
      def find(id)
        @@zones[id] ||= new DB[:zones].where(:id => id).first
      end

      def all
        DB[:zones].select(:id).order(:id).all.map{ |z| find(z[:id]) }
      end
    end
  end

  class Prefecture < OpenStruct
    @@prefectures = []
    def zone
      Zone.find(self.zone_id)
    end

    class << self
      def find(id)
        @@prefectures[id] ||= new DB[:prefectures].where(:id => id).first
      end

      def all
        DB[:prefectures].select(:id).order(:id).all.map{ |pr| find(pr[:id]) }
      end
    end
  end

  module Utils
    LAT_WIDTH = [nil,2400000,300000,150000, 75000,37500,18750, 9375  ]
    LON_WIDTH = [nil,3600000,450000,225000,112500,56250,28125,14062.5]
    class << self
      def lat_lng_to_meshcode(lat_deg, lng_deg)
        lat = (lat_deg * 3600000).to_i
        lng = (lng_deg * 3600000).to_i
        meshcode = ''
        la = lat
        lo = lng - 100*60*60*1000
        for i in 1..7
          a = (la / LAT_WIDTH[i]).to_i
          b = (lo / LON_WIDTH[i]).to_i
          la -= a * LAT_WIDTH[i]
          lo -= b * LON_WIDTH[i]
          case i
          when 1
            meshcode = sprintf("%02d%02d",a,b)
          when 2
            meshcode << sprintf("%d%d",a,b)
          else
            meshcode << sprintf("%d",a*2+b)
          end
        end
        return meshcode
      end

      def expand_meshcode(meshcode)
        (6..12).map do |n|
          meshcode[0, n]
        end
      end
    end
  end
end
