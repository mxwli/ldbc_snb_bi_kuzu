LOAD WITH HEADERS (PersonId INT64, UniversityId INT64, creationDate INT64, classYear INT32) FROM '$data_dir/inserts/dynamic/Person_studyAt_University/$batch/$csv_file' (header=true, delim='|')
MATCH (person:Person {id: PersonId}), (university:Organisation {type: "University", id: UniversityId})
CREATE (person)-[:STUDY_AT {creationDate: creationDate, classYear: classYear}]->(university)
RETURN count(*)
