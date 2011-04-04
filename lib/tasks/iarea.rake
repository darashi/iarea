require 'json'
require 'open-uri'
require 'tmpdir'
require 'tempfile'

namespace :iarea do
  desc "generate database"
  task :generate => ["fetch:def", "fetch:data"]

  namespace :fetch do
    desc "fetch iarea metadata"
    task :def do
      uri = "http://www.nttdocomo.co.jp/service/imode/make/content/iarea/domestic/map/js/iarea_def.js"
      tf = Tempfile.open("iarea")
      tf.write URI(uri).read
      tf.close
      ruby "./tools/import_areas.rb", tf.path, "db/iareadata.sqlite3"
    end

    desc "fetch iareadata.lzh"
    task :data do
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
        ruby "./tools/import_meshes.rb", dir, "db/iareadata.sqlite3"
      end
    end
  end
end
