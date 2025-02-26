MATCH
  (tag:Tag {name: $tag}),
  (person1:Person)<-[:HAS_CREATOR]-(message1:Post:Comment)-[:REPLY_OF*0..]->(post1:Post)<-[:CONTAINER_OF]-(forum1:Forum),
  (message1)-[:HAS_TAG]->(tag),


  (forum1)-[:HAS_MEMBER]->(person2:Person)<-[:HAS_CREATOR]-(comment:Comment)-[:HAS_TAG]->(tag),
  (forum1)-[:HAS_MEMBER]->(person3:Person)<-[:HAS_CREATOR]-(message2:Post:Comment),
  (comment)-[:REPLY_OF]->(message2)-[:REPLY_OF*0..]->(post2:Post)<-[:CONTAINER_OF]-(forum2:Forum)



MATCH (comment)-[:HAS_TAG]->(tag)
MATCH (message2)-[:HAS_TAG]->(tag)
WHERE forum1.id <> forum2.id
  AND message2.creationDate > message1.creationDate + INTERVAL('$delta HOURS')
  AND NOT (forum2)-[:HAS_MEMBER]->(person1)
RETURN person1.id, count(DISTINCT message2.id) AS messageCount
ORDER BY messageCount DESC, person1.id ASC
LIMIT 10
