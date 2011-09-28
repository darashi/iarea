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
        if prefecture = @@prefectures[id.to_i]
          prefecture
        elsif prefecture_data = DB['prefecture'][id.to_i]
          @@prefectures[id.to_i] ||= new(prefecture_data)
        else
          nil
        end
      end

      # All prefectures
      def all
        DB['prefecture_ids'].map{ |id| find(id) }
      end
    end
  end
end
