require "http/client"
require "json"

module IGDB
	VERSION = "4.0.0"

	# Crystal Client to interface with IGDB
	#
	# To create a client
	# ```
	# client = IGDB.new("my_id","my_token")
	# ```
	#
	# To use the client pass a *Hash* as a parameter with the required
	# query. So to search for Coming Soon Games for PS4
	# ```
	# client.get({"fields" => "*",
	#             "where" => "game.platforms = 48 * date < 1538129354",
	#             "sort" => "date desc"})
	# ```
	class Client
		URL = "https://api.igdb.com/v4/"

		property :client_id, :token, :endpoint

		# Initialize an IGDB::Client
		#
		# A Client ID and Token must be provided
		# The endpoint can be chosen (defaults to games)
		# All passed parameters can be changed after initialization
		# by using the associated property
		def initialize(@client_id : String, @token : String, @endpoint = "games")
		end

		# Run a query
		#
		# Query is constructed from the passed *Hash*
		# The query should contain keys and values that correspond to
		# IGDB Apicalypse queries.
		# *suffix* is used to append a suffix to the endpoint to
		# perform an action (e.g. count by passing "/count")
		def get(params = {"fields" => "*"}, suffix = "")
			header = HTTP::Headers{"Client-ID" => self.client_id,
			                       "Authorization" => "Bearer " + self.token}
			uri = URI.parse(URL+@endpoint+suffix)
			data = params.map do |k,v|
				"#{k.to_s} #{v};"
			end.join("")
			response = HTTP::Client.post(uri, headers: header, body: data)
			JSON.parse response.body
		end

		# Run a search on IGDB
		#
		# *title* will be the search string
		# additional parameters may optionaly be passed
		def search(title, params = {"fields" => "*"})
			params["search"] = '"' + title + '"'
			get params
		end

		# Get entry by ID
		#
		# *id* of requested entry needs to be passed
		# additional parameters may optionaly be passed
		def id(id, params = {"fields" => "*"})
			params["where"] = "id = #{id}"
			get params
		end

		# Get count of entries matching parameters
		def count(params = {"fields" => "*"})
			get(params, "/count")
		end

		macro method_missing(call)
			self.class.new(@client_id, @token, {{call.name.stringify}})
		end
	end
end
