LOAD WITH HEADERS (creationDate TIMESTAMP, id INT64, imageFile STRING, locationIP STRING, browserUsed STRING, language STRING, content STRING, length INT64) FROM '$data_dir/inserts/dynamic/Post/$batch/$csv_file' (header=true, delim='|')
CREATE (post:Post {
    creationDate: creationDate,
    id: id,
    imageFile: imageFile,
    locationIP: locationIP,
    browserUsed: browserUsed,
    language: language,
    content: content,
    length: length
  })
RETURN count(*)
