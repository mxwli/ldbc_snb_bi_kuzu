LOAD WITH HEADERS (PersonId INT64, CompanyId INT64, creationDate TIMESTAMP, workFrom INT64) FROM '$data_dir/inserts/dynamic/Person_workAt_Company/$batch/$csv_file' (header=true, delim='|')
MATCH (person:Person {id: PersonId}), (company:Organisation {type: "Company", id: CompanyId})
CREATE (person)-[:WORK_AT {creationDate: creationDate, workFrom: workFrom}]->(company)
RETURN count(*)
