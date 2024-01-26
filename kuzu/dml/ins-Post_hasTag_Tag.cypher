LOAD WITH HEADERS (PostId INT64, TagId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Post_hasTag_Tag/$batch/$csv_file' (header=true, delim='|')
MATCH (post:Post {id: PostId}), (tag:Tag {id: TagId})
CREATE (post)-[:HAS_TAG_Post_Tag {creationDate: creationDate}]->(tag)
RETURN count(*)
