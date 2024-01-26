LOAD WITH HEADERSE (PostId INT64, CountryId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Post_isLocatedIn_Country/$batch/$csv_file' (header=true, delim='|')
MATCH (post:Post {id: PostId}), (country:Place {type: "Country", id: CountryId})
CREATE (post)-[:IS_LOCATED_IN_Post_Place {creationDate: creationDate}]->(country)
RETURN count(*)
