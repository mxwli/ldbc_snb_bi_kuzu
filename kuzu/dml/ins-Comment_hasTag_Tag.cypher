LOAD (CommentId INT64, TagId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Comment_hasTag_Tag/$batch/$csv_file' (header=true, delim='|')
MATCH (comment:Comment {id: CommentId}), (tag:Tag {id: TagId})
CREATE (comment)-[:HAS_TAG_Comment_Tag {creationDate: creationDate}]->(tag)
RETURN count(*)
