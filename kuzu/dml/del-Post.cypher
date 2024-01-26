LOAD WITH HEADERS (deletionDate TIMESTAMP, id INT64) FROM '$data_dir/deletes/dynamic/Post/$batch/$csv_file' (header=true, delim='|')
MATCH (:Post {id: id})<-[:REPLY_OF*0..]-(message:Post:Comment) // DEL 6/7
DETACH DELETE message
RETURN count(*)
