LOAD WITH HEADERS (creationDate TIMESTAMP, id INT64, firstName STRING, lastName STRING, gender STRING, birthday DATE, locationIP STRING, browserUsed STRING, language STRING[], email STRING[]) FROM '$data_dir/inserts/dynamic/Person/$batch/$csv_file' (header=true, delim='|')
CREATE (p:Person {
    creationDate: creationDate,
    id: id,
    firstName: firstName,
    lastName: lastName,
    gender: gender,
    birthday: birthday,
    locationIP: locationIP,
    browserUsed: browserUsed,
    speaks: language,
    email: email
  })
RETURN count(*)
