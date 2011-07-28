module Iarea
  class Zone < OpenStruct
    @@zones = []

    # Prefectures in the zone
    def prefectures
      DB[:prefectures].where(:zone_id => self.id).select(:id).order(:id).map do |prefecture|
        Prefecture.find(prefecture[:id])
      end
    end

    # Areas in the zone
    def areas
      DB[:areas].where(:zone_id => self.id).select(:areacode).order(:areacode).map do |area|
        Area.find(area[:areacode])
      end
    end

    class << self
      # Find a zone by <tt>id</tt>
      def find(id)
        @@zones[id] ||= new DB[:zones].where(:id => id).first
      end

      # All zones
      def all
        DB[:zones].select(:id).order(:id).all.map{ |z| find(z[:id]) }
      end
    end
  end
end
