HAMMY FRONTEND
==============

INSTALL
-------
Ruby gems:
    gem install sinatra
    gem install couchbase

Couchbase view:
    {
      "_id": "_design/hammy",
      "language": "javascript",
      "views": {
        "all_keys": {
          "map": "function (doc, meta) {emit(meta.id, null);}"
        }
      }
    }

RUN
---
    ./cfg.rb
