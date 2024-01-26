LOAD WITH HEADERS (CommentId INT64, CountryId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Comment_isLocatedIn_Country/$batch/$csv_file' (header=true, delim='|')
MATCH (comment:Comment {id: CommentId}), (country:Place {type: "Country", id: CountryId})
CREATE (comment)-[:IS_LOCATED_IN_Comment_Place {creationDate: creationDate}]->(country)
RETURN count(*)
