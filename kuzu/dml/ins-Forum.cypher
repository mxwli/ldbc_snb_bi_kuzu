LOAD WITH HEADERS (creationDate TIMESTAMP, id INT64, title STRING) FROM '$data_dir/inserts/dynamic/Forum/$batch/$csv_file' (header=true, delim='|')
CREATE (f:Forum {
    creationDate: creationDate,
    id: id,
    title: title
  })
RETURN count(*);
