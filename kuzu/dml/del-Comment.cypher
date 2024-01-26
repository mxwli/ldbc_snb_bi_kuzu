LOAD WITH HEADERS (deletionDate TIMESTAMP, id INT64) FROM '$data_dir/deletes/dynamic/Comment/$batch/$csv_file' (header=true, delim='|')
MATCH (:Comment {id: id})<-[:REPLY_OF*0..]-(comment:Comment)
DETACH DELETE comment
RETURN count(*)
