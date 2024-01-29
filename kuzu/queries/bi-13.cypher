MATCH (country:Place {type: "Country", name: $country})<-[:IS_PART_OF]-(:Place {type: "City"})<-[:IS_LOCATED_IN]-(zombie:Person)
WHERE zombie.creationDate < $endDate
WITH country, zombie
OPTIONAL MATCH (zombie)<-[:HAS_CREATOR]-(message:Post:Comment)
WHERE message.creationDate < $endDate
WITH
  country,
  zombie,
  count(message) AS messageCount
WITH
  country,
  zombie,
  12 * (date_part('year', $endDate) - date_part('year', zombie.creationDate))
     + (date_part('month', $endDate) - date_part('month', zombie.creationDate))
     + 1 AS months,
  messageCount
WHERE messageCount / months < 1
WITH
  country,
  collect(zombie) AS zombies
UNWIND zombies AS zombie
MATCH (zombie1:Person) WHERE zombie1.id = zombie.id
WITH
  country,
  zombies,
  zombie,
  zombie1
OPTIONAL MATCH
  (zombie1)<-[:HAS_CREATOR]-(message:Post:Comment)<-[:LIKES]-(likerZombie:Person)
WHERE list_contains(zombies, likerZombie)
WITH
  zombie,
  zombie1,
  count(likerZombie) AS zombieLikeCount
OPTIONAL MATCH
  (zombie1)<-[:HAS_CREATOR]-(message:Post:Comment)<-[:LIKES]-(likerPerson:Person)
WHERE likerPerson.creationDate < $endDate
WITH
  zombie,
  zombieLikeCount,
  count(likerPerson) AS totalLikeCount
RETURN
  zombie.id,
  zombieLikeCount,
  totalLikeCount,
  CASE totalLikeCount
    WHEN 0 THEN 0.0
    ELSE zombieLikeCount / to_float(totalLikeCount)
  END AS zombieScore
ORDER BY
  zombieScore DESC,
  zombie.id ASC
LIMIT 100
