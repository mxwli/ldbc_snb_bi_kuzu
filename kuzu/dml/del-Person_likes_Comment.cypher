LOAD WITH HEADERS (PersonId INT64, CommentId INT64, deletionDate TIMESTAMP) FROM '$data_dir/deletes/dynamic/Person_likes_Comment/$batch/$csv_file' (header=true, delim='|')
MATCH (:Person {id: PersonId})-[likes:LIKES]->(:Comment {id: CommentId})
DELETE likes
RETURN count(*)
