UNWIND [
    {letter: 'A', tag: $tagA, date: $dateA},
    {letter: 'B', tag: $tagB, date: $dateB}
  ] AS param
WITH param.letter AS paramLetter, param.tag AS paramTagX, param.date AS paramDateX
MATCH (person1:Person)<-[:HAS_CREATOR]-(message1:Post:Comment)-[:HAS_TAG]->(tag:Tag {name: paramTagX})
WHERE date(message1.creationDate) = date(paramDateX)
OPTIONAL MATCH (person1)-[:KNOWS]-(person2:Person)<-[:HAS_CREATOR]-(message2:Post:Comment)-[:HAS_TAG]->(tag)
WHERE date(message2.creationDate) = date(paramDateX)
WITH person1, count(DISTINCT message1) AS cm, count(DISTINCT person2) AS cp2
WHERE cp2 <= $maxKnowsLimit
WITH person1, cm
WITH person1, collect({letter: paramLetter, messageCount: cm}) AS results
WHERE size(results) = 2
RETURN
  person1.id,
  [list_contains(results, r) WHERE r.letter = 'A' | r.messageCount][0] AS messageCountA,
  [list_contains(results, r) WHERE r.letter = 'B' | r.messageCount][0] AS messageCountB
ORDER BY messageCountA + messageCountB DESC, person1.id ASC
LIMIT 20
