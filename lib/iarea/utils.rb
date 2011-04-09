module Iarea
  module Utils
    LAT_WIDTH = [nil,2400000,300000,150000, 75000,37500,18750, 9375  ]
    LON_WIDTH = [nil,3600000,450000,225000,112500,56250,28125,14062.5]
    class << self
      def lat_lng_to_meshcode(lat_deg, lng_deg)
        lat = (lat_deg * 3600000).to_i
        lng = (lng_deg * 3600000).to_i
        meshcode = ''
        la = lat
        lo = lng - 100*60*60*1000
        for i in 1..7
          a = (la / LAT_WIDTH[i]).to_i
          b = (lo / LON_WIDTH[i]).to_i
          la -= a * LAT_WIDTH[i]
          lo -= b * LON_WIDTH[i]
          case i
          when 1
            meshcode = sprintf("%02d%02d",a,b)
          when 2
            meshcode << sprintf("%d%d",a,b)
          else
            meshcode << sprintf("%d",a*2+b)
          end
        end
        return meshcode
      end

      def expand_meshcode(meshcode)
        (6..12).map do |n|
          meshcode[0, n]
        end
      end
    end
  end
end
