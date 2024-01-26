LOAD WITH HEADERS (creationDate TIMESTAMP, id INT64, locationIP STRING, browserUsed STRING, content STRING, length INT64) FROM '$data_dir/inserts/dynamic/Comment/$batch/$csv_file' (header=true, delim='|')
CREATE (c:Comment {
    creationDate: creationDate,
    id: to_int64(id),
    locationIP: locationIP,
    browserUsed: browserUsed,
    content: content,
    length: length
  })
RETURN count(*)
