# IVLE forum downloader

## Disclaimer

I wrote this script to archive one of my module's forums because even though it
contained thousands of excellent posts, access to it was removed at the end of
the semester as per standard protocol.

If you do download information from IVLE, please use them for your personal
education purposes only. Rehosting of such information might be against the
school's policy.

## Requirements

- Ruby
- MongoDB

## Usage

You'll need to obtain your API key and auth token, add them to keys.yml.sample
and rename the file to keys.yml.

The script is currently hardcoded to download from a specific forum, so you
will have to obtain the heading ID of the forum you want.

```shell
bundle
mongod --dbpath /your/choice/of/db/path/
ruby scrape_forum.rb
```

Implemented features
- Validation of auth token
- Pulling of all main threads from a forum into a JSON file
- Writing to a MongoDB collection

TODO
- Optparsing of arguments
- Automate fetching of FORUM_ID and HEADING_ID
- Automate fetching of auth token by providing API key
- Frontend
