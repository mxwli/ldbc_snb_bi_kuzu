LOAD WITH HEADERS (PersonId INT64, CommentId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Person_likes_Comment/$batch/$csv_file' (header=true, delim='|')
MATCH (person:Person {id: PersonId}), (comment:Comment {id: CommentId})
CREATE (person)-[:LIKES_Person_Comment {creationDate: creationDate}]->(comment)
RETURN count(*)
