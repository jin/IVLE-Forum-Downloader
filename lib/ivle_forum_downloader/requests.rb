module IVLEForumDownloader

  module Requests

    include Configuration

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
