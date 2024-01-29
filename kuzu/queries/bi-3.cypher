MATCH
  (:Place {type: "Country", name: $country})<-[:IS_PART_OF]-(:Place {type: "City"})<-[:IS_LOCATED_IN]-
  (person:Person)<-[:HAS_MODERATOR]-(forum:Forum)-[:CONTAINER_OF]->
  (post:Post)<-[:REPLY_OF*0..]-(message:Post:Comment)-[:HAS_TAG]->(:Tag)-[:HAS_TYPE]->(:TagClass {name: $tagClass})
RETURN
  forum.id,
  forum.title,
  forum.creationDate,
  person.id,
  count(DISTINCT message.id) AS messageCount
ORDER BY
  messageCount DESC,
  forum.id ASC
LIMIT 20
