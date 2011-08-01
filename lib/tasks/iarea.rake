require 'json'
require 'open-uri'
require 'tmpdir'
require 'tempfile'

namespace :iarea do
  desc "generate data"
  task :generate do
    # fetch iarea metadata
    uri = "http://www.nttdocomo.co.jp/service/imode/make/content/iarea/domestic/map/js/iarea_def.js"
    tf = Tempfile.open("iarea")
    tf.write URI(uri).read
    tf.close

    # fetch and extract iareadata.lzh
    Dir.mktmpdir("iareadata") do |dir|
      Dir.chdir(dir) do
        uri = "http://www.nttdocomo.co.jp/binary/archive/service/imode/make/content/iarea/domestic/iareadata.lzh"
        File.open("iareadata.lzh", "w") do |f|
          f.write URI(uri).read
        end
        unless system("lha", "xf", "iareadata.lzh")
          raise "lha failed"
        end
      end

      ruby './tools/generate.rb', 'db', tf.path, dir
    end
  end
end
