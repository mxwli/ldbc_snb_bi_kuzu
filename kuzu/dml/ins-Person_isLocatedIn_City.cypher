LOAD WITH HEADERS (PersonId INT64, CityId INT64, creationDate TIMESTAMP) FROM '$data_dir/inserts/dynamic/Person_isLocatedIn_City/$batch/$csv_file' (header=true, delim='|')
MATCH (person:Person {id: PersonId}), (city:Place {type: "City", id: CityId})
CREATE (person)-[:IS_LOCATED_IN_Person_Place {creationDate: creationDate}]->(city)
RETURN count(*)
