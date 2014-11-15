require 'yaml'
require 'faraday'
require 'faraday_middleware'
require 'active_support'
require 'json'
require 'pp'
require 'mongo'

module IVLEForumDownloader

  class << self

    include Mongo

    config = YAML::load_file "keys.yml"

    APIKEY = config["apikey"]
    TOKEN = config["token"]
    MODULE = "GEK1508"

    # TODO: Find a method to obtain this automatically.
    FORUM_ID = "7787ab6d-5219-4f09-8975-7d855761c661"
    HEADING_ID = "eec30ee3-59a9-47d3-9dda-8c3385d24076"

    def start
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

    def validate_user
      get "Validate?APIKey=#{APIKEY}&Token=#{TOKEN}"
    end

    # Set duration to 0 to get everything
    def get_forum_info
      get "Forum?APIKey=#{APIKEY}&AuthToken=#{TOKEN}&ForumID=#{FORUM_ID}&Duration=10&IncludeThreads=true"
    end

    # Use this to get the HEADING_ID of the forum
    def get_forum_headings
      get "Forum_Headings?APIKey=#{APIKEY}&AuthToken=#{TOKEN}&ForumID=#{FORUM_ID}&Duration=10&IncludeThreads=false"
    end

    def get_threads
      get "Forum_HeadingThreads?APIKey=#{APIKEY}&AuthToken=#{TOKEN}&HeadingID=#{HEADING_ID}&Duration=0&GetMainTopicsOnly=true"
    end

    def get_entire_thread(thread_id)
      get "Forum_Threads?APIKey=#{APIKEY}&AuthToken=#{TOKEN}&ThreadID=#{thread_id}&Duration=0&GetSubThreads=true"
    end

  end

end

IVLEForumDownloader.start
