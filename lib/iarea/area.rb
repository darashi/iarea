module Iarea
  class Area < OpenStruct
    @@areas = {}
    def prefecture
      Prefecture.find(self.prefecture_id)
    end

    def zone
      Zone.find(self.zone_id)
    end

    def neighbors
      DB[:neighbors].where(:areacode => areacode).select(:neighbor_areacode).map do |neighbor|
        Area.find neighbor[:neighbor_areacode]
      end
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
end
