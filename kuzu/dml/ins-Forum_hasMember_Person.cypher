LOAD WITH HEADERS (ForumId INT64, PersonId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Forum_hasMember_Person/$batch/$csv_file' (header=true, delim='|')
MATCH (forum:Forum {id: ForumId}), (person:Person {id: PersonId})
CREATE (forum)-[:HAS_MEMBER {creationDate: creationDate}]->(person)
RETURN count(*)
