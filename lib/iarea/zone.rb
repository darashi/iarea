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
        id = id.to_s
        @@zones[id] ||= new JSON.parse(DB['z:'+id])
      end

      # All zones
      def all
        JSON.parse(DB['z']).map{ |id| find(id) }
      end
    end
  end
end
