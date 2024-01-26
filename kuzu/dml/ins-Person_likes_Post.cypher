LOAD WITH HEADERS (PersonId INT64, PostId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Person_likes_Post/$batch/$csv_file' (header=true, delim='|')
MATCH (person:Person {id: PersonId}), (post:Post {id: PostId})
CREATE (person)-[:LIKES_Person_Post {creationDate: creationDate}]->(post)
RETURN count(*)
