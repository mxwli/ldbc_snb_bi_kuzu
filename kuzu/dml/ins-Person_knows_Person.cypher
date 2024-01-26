LOAD WITH HEADERS (Person1Id INT64, Person2Id INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Person_knows_Person/$batch/$csv_file' (header=true, delim='|')
MATCH (person1:Person {id: Person1Id}), (person2:Person {id: Person2Id})
CREATE (person1)-[:KNOWS {creationDate: creationDate}]->(person2)
RETURN count(*)
