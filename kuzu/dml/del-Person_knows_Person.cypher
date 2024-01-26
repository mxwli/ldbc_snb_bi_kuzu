LOAD WITH HEADERS (Person1Id INT64, Person2Id INT64, deletionDate TIMESTAMP) FROM '$data_dir/deletes/dynamic/Person_knows_Person/$batch/$csv_file' (header=true, delim='|')
MATCH (:Person {id: Person1Id})-[knows:KNOWS]-(:Person {id: Person2Id})
DELETE knows
RETURN count(*)
