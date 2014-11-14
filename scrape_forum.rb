require 'yaml'
require 'faraday'
require 'faraday_middleware'
require 'active_support'
require 'multi_xml'
require 'json'
require 'pp'

config = YAML::load_file "keys.yml"

APIKEY = config["apikey"]
TOKEN = config["token"]
GEK1518_FORUM_ID = "7787ab6d-5219-4f09-8975-7d855761c661"
GEK1518_HEADING_ID = "eec30ee3-59a9-47d3-9dda-8c3385d24076"

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
  get "/Validate?APIKey=#{APIKEY}&Token=#{TOKEN}"
end

def get_username
  get "UserName_Get?APIKey=#{APIKEY}&Token=#{TOKEN}"
end

# Set duration to 0 to get everything
def get_forum_info
  get "Forum?APIKey=#{APIKEY}&AuthToken=#{TOKEN}&ForumID=#{GEK1518_FORUM_ID}&Duration=10&IncludeThreads=true"
end

# Use this to get the HEADING_ID of the forum
def get_forum_headings
  get "Forum_Headings?APIKey=#{APIKEY}&AuthToken=#{TOKEN}&ForumID=#{GEK1518_FORUM_ID}&Duration=100&IncludeThreads=false"
end

def get_threads
  get "Forum_HeadingThreads?APIKey=#{APIKEY}&AuthToken=#{TOKEN}&HeadingID=#{GEK1518_HEADING_ID}&Duration=0&GetMainTopicsOnly=true"
end

def main
  validate_user
  File.open("data.json", "w") do |f|
    f.write JSON.pretty_generate(JSON.parse(get_threads.body))
  end 
end

main