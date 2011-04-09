module Iarea
  # Prefecture
  class Prefecture < OpenStruct
    @@prefectures = []

    # Zone of the prefecture
    def zone
      Zone.find(self.zone_id)
    end

    # Areas in the prefecture
    def areas
      DB[:areas].where(:prefecture_id => self.id).select(:areacode).order(:areacode).map do |area|
        Area.find(area[:areacode])
      end
    end

    class << self
      # Find a prefecture by <tt>id</tt>
      def find(id)
        @@prefectures[id] ||= new DB[:prefectures].where(:id => id).first
      end

      # All prefectures
      def all
        DB[:prefectures].select(:id).order(:id).all.map{ |pr| find(pr[:id]) }
      end
    end
  end
end
