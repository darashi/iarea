module Iarea
  class Prefecture < OpenStruct
    @@prefectures = []
    def zone
      Zone.find(self.zone_id)
    end

    def areas
      DB[:areas].where(:prefecture_id => self.id).select(:areacode).order(:areacode).map do |area|
        Area.find(area[:areacode])
      end
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
end
