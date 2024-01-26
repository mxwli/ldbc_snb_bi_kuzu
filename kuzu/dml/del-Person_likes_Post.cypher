LOAD WITH HEADERS (PersonId INT64, PostId INT64, deletionDate TIMESTAMP) FROM '$data_dir/deletes/dynamic/Person_likes_Post/$batch/$csv_file' (header=true, delim='|')
MATCH (:Person {id: PersonId})-[likes:LIKES]->(:Post {id: PostId})
DELETE likes
RETURN count(*)
