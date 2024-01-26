MATCH (tag:Tag)-[:HAS_TYPE]->(:TagClass {name: $tagClass})

OPTIONAL MATCH (message1:Post:Comment)-[:HAS_TAG]->(tag)
  WHERE $date <= message1.creationDate
    AND message1.creationDate < $date + INTERVAL('100 DAYS')
WITH tag, count(message1) AS countWindow1

OPTIONAL MATCH (message2:Post:Comment)-[:HAS_TAG]->(tag)
  WHERE $date + INTERVAL('100 DAYS') <= message2.creationDate
    AND message2.creationDate < $date + INTERVAL('200 DAYS')
WITH
  tag,
  countWindow1,
  count(message2) AS countWindow2
RETURN
  tag.name,
  countWindow1,
  countWindow2,
  abs(countWindow1 - countWindow2) AS diff
ORDER BY
  diff DESC,
  tag.name ASC
LIMIT 100
