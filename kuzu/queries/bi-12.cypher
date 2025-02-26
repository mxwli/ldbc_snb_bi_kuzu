MATCH (person:Person)
WITH person
OPTIONAL MATCH (person)<-[:HAS_CREATOR]-(message:Post:Comment)-[:REPLY_OF*0..]->(post:Post)
WHERE message.content IS NOT NULL
  AND message.length < $lengthThreshold
  AND message.creationDate > $startDate
  AND list_contains($languages, post.language)
WITH
  person,
  count(message) AS messageCount
RETURN
  messageCount,
  count(person) AS personCount
ORDER BY
  personCount DESC,
  messageCount DESC
