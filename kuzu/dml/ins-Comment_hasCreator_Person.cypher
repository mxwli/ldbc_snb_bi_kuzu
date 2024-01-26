LOAD WITH HEADERS (CommentId INT64, PersonId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Comment_hasCreator_Person/$batch/$csv_file' (header=true, delim='|')
MATCH (comment:Comment {id: CommentId}), (person:Person {id: PersonId})
CREATE (comment)-[:HAS_CREATOR_Comment_Person {creationDate: creationDate}]->(person)
RETURN count(*)
