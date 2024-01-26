LOAD WITH HEADERS (deletionDate TIMESTAMP, id INT64) FROM '$data_dir/deletes/dynamic/Forum/$batch/$csv_file' (header=true, delim='|')
MATCH (forum:Forum {id: id})
OPTIONAL MATCH (forum)-[:CONTAINER_OF]->(:Post)<-[:REPLY_OF*0..]-(message:Post:Comment)
DETACH DELETE forum, message
RETURN count(*)
