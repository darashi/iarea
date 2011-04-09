module Iarea
  class Zone < OpenStruct
    @@zones = []

    def prefectures
      DB[:prefectures].where(:zone_id => self.id).select(:id).order(:id).map do |prefecture|
        Prefecture.find(prefecture[:id])
      end
    end

    def areas
      DB[:areas].where(:zone_id => self.id).select(:areacode).order(:areacode).map do |area|
        Area.find(area[:areacode])
      end
    end

    class << self
      def find(id)
        @@zones[id] ||= new DB[:zones].where(:id => id).first
      end

      def all
        DB[:zones].select(:id).order(:id).all.map{ |z| find(z[:id]) }
      end
    end
  end
end
