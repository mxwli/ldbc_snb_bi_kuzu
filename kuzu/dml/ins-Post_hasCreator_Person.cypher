LOAD WITH HEADERS (PostId INT64, Personid INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Post_hasCreator_Person/$batch/$csv_file' (header=true, delim='|')
MATCH (post:Post {id: PostId}), (person:Person {id: PersonId})
CREATE (post)-[:HAS_CREATOR_Post_Person {creationDate: creationDate}]->(person)
RETURN count(*)
