LOAD WITH HEADERS (Comment1Id INT64, Comment2Id INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Comment_replyOf_Comment/$batch/$csv_file' (header=true, delim='|')
MATCH (comment:Comment {id: CommentId}), (parentComment:Comment {id: Comment2Id})
CREATE (comment)-[:REPLY_OF_Comment_Comment {creationDate: creationDate}]->(parentComment)
RETURN count(*)
