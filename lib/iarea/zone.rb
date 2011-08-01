module Iarea
  class Zone < OpenStruct
    @@zones = {}

    # Prefectures in the zone
    def prefectures
      self.prefecture_ids.map {|prefecture_id| Prefecture.find prefecture_id}
    end

    # Areas in the zone
    def areas
      self.areacodes.map {|areacode| Area.find areacode}
    end

    class << self
      # Find a zone by <tt>id</tt>
      def find(id)
        @@zones[id.to_i] ||= new DB['zone'][id.to_i]
      end

      # All zones
      def all
        DB['zone_ids'].map{|id| Zone.find id}
      end
    end
  end
end
