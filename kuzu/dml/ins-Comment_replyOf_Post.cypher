LOAD WITH HEADERS (CommentId INT64, PostId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Comment_replyOf_Post/$batch/$csv_file' (header=true, delim='|')
MATCH (comment:Comment {id: CommentId}), (post:Post {id: PostId})
CREATE (comment)-[:REPLY_OF_Comment_Post {creationDate: creationDate}]->(post)
RETURN count(*)
