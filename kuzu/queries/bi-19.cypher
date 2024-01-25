// Q19. Interaction path between cities
// does not follow specifications.
/*
:params { city1Id: 669, city2Id: 648 }
*/
MATCH
	(person1:Person)-[:IS_LOCATED_IN]->(city1:Place {type: "City", id: $city1Id}),
	(person2:Person)-[:IS_LOCATED_IN]->(city2:Place {type: "City", id: $city2Id}),
	(person1)->[]
