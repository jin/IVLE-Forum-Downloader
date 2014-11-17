module IVLEForumDownloader

  module Configuration

    config = YAML::load_file "keys.yml"
    APIKEY = config["apikey"]
    TOKEN = config["token"]

    # TODO: Find a method to obtain this automatically.
    MODULE = "GEK1508"
    FORUM_ID = "7787ab6d-5219-4f09-8975-7d855761c661"
    HEADING_ID = "eec30ee3-59a9-47d3-9dda-8c3385d24076"

  end

end
