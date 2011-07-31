module Iarea
  # Prefecture
  class Prefecture < OpenStruct
    @@prefectures = {}

    # Zone of the prefecture
    def zone
      Zone.find(self.zone_id)
    end

    # Areas in the prefecture
    def areas
      self.areacodes.map{|areacode| Area.find areacode}
    end

    class << self
      # Find a prefecture by <tt>id</tt>
      def find(id)
        id = id.to_s
        @@prefectures[id] ||= new JSON.parse(DB['p:'+id])
      end

      # All prefectures
      def all
        JSON.parse(DB['p']).map{ |id| find(id) }
      end
    end
  end
end
