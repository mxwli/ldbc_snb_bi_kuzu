MATCH (tag:Tag {name: $tag})<-[:HAS_INTEREST]-(person1:Person)-[:KNOWS]-(mutualFriend:Person)-[:KNOWS]-(person2:Person)-[:HAS_INTEREST]->(tag)
WHERE person1.id <> person2.id
  AND NOT (person1)-[:KNOWS]-(person2)
RETURN person1.id AS person1Id, person2.id AS person2Id, count(DISTINCT mutualFriend.id) AS mutualFriendCount
ORDER BY mutualFriendCount DESC, person1Id ASC, person2Id ASC
LIMIT 20
