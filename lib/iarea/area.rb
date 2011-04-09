module Iarea
  # Area
  class Area < OpenStruct
    @@areas = {}

    # Prefecture of the area
    def prefecture
      Prefecture.find(self.prefecture_id)
    end

    # Zone of the area
    def zone
      Zone.find(self.zone_id)
    end

    # Neighbor areas of the area
    def neighbors
      DB[:neighbors].where(:areacode => areacode).select(:neighbor_areacode).map do |neighbor|
        Area.find neighbor[:neighbor_areacode]
      end
    end

    class << self
      # Find area by <tt>areacode</tt>
      def find(areacode)
        @@areas[areacode] ||= new DB[:areas].where(:areacode => areacode).first
      end

      # Find area by latitude and longitude in degrees
      def find_by_lat_lng(lat, lng)
        meshcodes = Utils.expand_meshcode(Utils.lat_lng_to_meshcode(lat, lng))
        area = DB[:meshes].where(:meshcode => meshcodes).select(:areacode).first
        return nil if area.nil?
        find(area[:areacode])
      end
    end
  end
end
