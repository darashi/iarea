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
        @@prefectures[id.to_i] ||= new DB['prefecture'][id.to_i]
      end

      # All prefectures
      def all
        DB['prefecture_ids'].map{ |id| find(id) }
      end
    end
  end
end
