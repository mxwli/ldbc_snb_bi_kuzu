LOAD WITH HEADERS (personId INT64, interestId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Person_hasInterest_Tag/$batch/$csv_file' (header=true, delim='|')
MATCH (person:Person {id: personId}), (tag:Tag {id: interestId})
CREATE (person)-[:HAS_INTEREST {creationDate: creationDate}]->(tag)
RETURN count(*)
