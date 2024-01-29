MATCH (person:Person)<-[:HAS_CREATOR]-(post:Post)<-[:REPLY_OF*0..]-(reply:Post:Comment)
WHERE  post.creationDate >= $startDate
  AND  post.creationDate <= $endDate
  AND reply.creationDate >= $startDate
  AND reply.creationDate <= $endDate
RETURN
  person.id,
  person.firstName,
  person.lastName,
  count(DISTINCT post.id) AS threadCount,
  count(DISTINCT reply.id) AS messageCount
ORDER BY
  messageCount DESC,
  person.id ASC
LIMIT 100
