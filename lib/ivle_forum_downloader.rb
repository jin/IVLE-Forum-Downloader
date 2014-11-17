$:.unshift File.join(File.dirname(__FILE__))

require 'yaml'
require 'json'
require 'faraday'
require 'faraday_middleware'
require 'active_support'
require 'pp'
require 'mongo'
require 'optparse'

require 'ivle_forum_downloader/configuration.rb'
require 'ivle_forum_downloader/requests.rb'

module IVLEForumDownloader

  class << self

    include Mongo

    include Requests

    def start(opts)
      validate_user
      download_threads database.collection("threads")
    end

    def download_threads(collection = nil)
      File.open("data.json", "w") do |f|
        body = JSON.parse(get_threads.body)
        threads_count = body["Results"].length

        body["Results"].each_with_index do |thread, idx|
          puts "Downloading thread: #{idx + 1} / #{threads_count}"
          data = JSON.parse(get_entire_thread(thread["ID"]).body)

          collection.insert(data)
          f.write JSON.pretty_generate(data)
        end
      end
    end

    def database
      MongoClient.new('localhost', 27017).db(MODULE)
    end

    def conn
      Faraday.new("https://ivle.nus.edu.sg/api/Lapi.svc/") do |conn|
        conn.use :instrumentation
        conn.adapter Faraday.default_adapter
      end
    end

    def get(url)
      conn.get url
    end

  end

end

#=========================================
# Option parsing from command line
#=========================================

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby download.rb [options]"

  opts.on("-o", "--output filename", "Output file") do |o|
    options[:output] = o
  end

  opts.on("-m", "--multithread count", Integer, "Enable multithreading and specify the number of threads. Default = 1 (single-thread).") do |t|
    options[:threads] = t
  end

  opts.on("-v", "--verbose", "Verbose mode") do |v|
    options[:verbose] = v
  end
end.parse!

IVLEForumDownloader.start(options)
