MATCH (a:Person)-[:IS_LOCATED_IN]->(:Place {type: "City"})-[:IS_PART_OF]->(country:Place {type: "Country", name: $country}),
      (a)-[k1:KNOWS]-(b:Person)
WHERE a.id < b.id
  AND $startDate <= k1.creationDate AND k1.creationDate <= $endDate
WITH DISTINCT country, a, b
MATCH (b)-[:IS_LOCATED_IN]->(:Place {type: "City"})-[:IS_PART_OF]->(country)
WITH DISTINCT country, a, b
MATCH (b)-[k2:KNOWS]-(c:Person),
      (c)-[:IS_LOCATED_IN]->(:Place {type: "City"})-[:IS_PART_OF]->(country)
WHERE b.id < c.id
  AND $startDate <= k2.creationDate AND k2.creationDate <= $endDate
WITH DISTINCT a, b, c
MATCH (c)-[k3:KNOWS]-(a)
WHERE $startDate <= k3.creationDate AND k3.creationDate <= $endDate
WITH DISTINCT a, b, c
RETURN count(*) AS count
