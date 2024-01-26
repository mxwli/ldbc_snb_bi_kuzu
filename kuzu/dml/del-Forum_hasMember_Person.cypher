LOAD WITH HEADERS (ForumId INT64, PersonId INT64, deletionDate TIMESTAMP) FROM '$data_dir/deletes/dynamic/Forum_hasMember_Person/$batch/$csv_file' (header=true, delim='|')
MATCH (:Forum {id: ForumId})-[hasMember:HAS_MEMBER]->(:Person {id: PersonId})
DELETE hasMember
RETURN count(*)
