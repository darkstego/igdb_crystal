# IGDB

Crystal wrapper for the [IGDB](https://www.igdb.com/)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     igdb:
       github: darkstego/igdb_crystal
   ```

2. Run `shards install`

## Usage

```crystal
require "igdb"

client = IGDB.new("my_id","my_token")

# Search for comming soon PS4 games
client.get {"fields" => "*",
            "where" => "game.platforms = 48 * date < 1538129354",
            "sort" => "date desc"}

# Search for 'Mario Kart' games 
client.search "Mario Kart"

# Temprarily switch endpoint
client.characters.id 55  #finds character with id 55
client.id 55             #finds game with id 55

# Permanently switch endpoint
client.endpoint = "characters"

# Count Matches
client.count

```

## Contributing

1. Fork it (<https://github.com/darkstego/igdb_crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Abdulla Bubshait](https://github.com/darkstego) - creator and maintainer
