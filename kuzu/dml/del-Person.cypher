LOAD WITH HEADERS (deletionDate TIMESTAMP, id INT64) FROM '$data_dir/deletes/dynamic/Person/$batch/$csv_file' (header=true, delim='|')
MATCH (person:Person {id: id})
// DEL 6/7: Post/Comment
OPTIONAL MATCH (person)<-[:HAS_CREATOR]-(:Post:Comment)<-[:REPLY_OF*0..]-(message1:Post:Comment)
// DEL 4: Forum
OPTIONAL MATCH (person)<-[:HAS_MODERATOR]-(forum:Forum)
WHERE forum.title STARTS WITH 'Album '
   OR forum.title STARTS WITH 'Wall '
OPTIONAL MATCH (forum)-[:CONTAINER_OF]->(:Post)<-[:REPLY_OF*0..]-(message2:Post:Comment)
DETACH DELETE person, forum, message1, message2
RETURN count(*)
