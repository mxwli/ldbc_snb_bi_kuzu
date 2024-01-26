LOAD WITH HEADERS (ForumId INT64, PostId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Forum_containerOf_Post/$batch/$csv_file' (header=true, delim='|')
MATCH (forum:Forum {id: ForumId}), (post:Post {id: PostId})
CREATE (forum)-[:CONTAINER_OF {creationDate: creationDate}]->(post)
RETURN count(*)
