LOAD WITH HEADERS (ForumId INT64, TagId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Forum_hasTag_Tag/$batch/$csv_file' (header=true, delim='|')
MATCH (forum:Forum {id: ForumId}), (tag:Tag {id: TagId})
CREATE (forum)-[:HAS_TAG_Forum_Tag {creationDate: creationDate}]->(tag)
RETURN count(*)
