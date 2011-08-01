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
      @table[:neighbors].map{|areacode| Area.find areacode}
    end

    class << self
      # Find area by <tt>areacode</tt>
      def find(areacode)
        @@areas[areacode] ||= new DB['area'][areacode]
      end

      # Find area by latitude and longitude in degrees
      def find_by_lat_lng(lat, lng)
        meshcodes = Utils.expand_meshcode(Utils.lat_lng_to_meshcode(lat, lng))
        meshcodes.each do |meshcode|
          if areacode = MESH[meshcode]
            return find(areacode)
          end
        end
        return nil
      end
    end
  end
end
