MATCH (tag:Tag {name: $tag})

OPTIONAL MATCH (tag)<-[interest:HAS_INTEREST]-(person:Person)
WITH tag, collect(person) AS interestedPersons
OPTIONAL MATCH (tag)<-[:HAS_TAG]-(message:Post:Comment)-[:HAS_CREATOR]->(person:Person)
         WHERE $startDate < message.creationDate
           AND message.creationDate < $endDate
WITH tag, interestedPersons, interestedPersons + collect(person) AS persons
UNWIND persons AS person
MATCH (person1:Person) WHERE person1.id = person.id
WITH tag, interestedPersons, persons, person, person1
WITH DISTINCT tag, person
WITH
  tag,
  person,
  100 * COUNT { MATCH (tag)<-[interest:HAS_INTEREST]-(person1) } + COUNT { MATCH (tag)<-[:HAS_TAG]-(message:Post:Comment)-[:HAS_CREATOR]->(person1) WHERE $startDate < message.creationDate AND message.creationDate < $endDate }
  AS score
OPTIONAL MATCH (person1)-[:KNOWS]-(friend)


WITH
  person,
  score,
  100 * count { match (tag)<-[interest:HAS_INTEREST]-(friend) } + COUNT { MATCH (tag)<-[:HAS_TAG]-(message:Post:Comment)-[:HAS_CREATOR]->(friend) WHERE $startDate < message.creationDate AND message.creationDate < $endDate }
  AS friendScore
WITH
  person.id AS pid,
  score,
  sum(friendScore) AS friendsScore,
  score + sum(friendScore) as order_col1
RETURN
  pid,
  score,
  friendsScore
ORDER BY
  order_col1 DESC,
  pid ASC
LIMIT 100
