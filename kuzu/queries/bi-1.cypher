MATCH (message:Post:Comment)
WHERE message.creationDate < $datetime
WITH count(message) AS totalMessageCountInt
WITH to_float(totalMessageCountInt) AS totalMessageCount
MATCH (message:Post:Comment)
WHERE message.creationDate < $datetime
  AND message.content IS NOT NULL
WITH
  totalMessageCount,
  message,
  date_part('year', message.creationDate) AS year
WITH
  totalMessageCount,
  year,
  LABEL(message) = "Comment" AS isComment,
  CASE
    WHEN message.length <  40 THEN 0
    WHEN message.length <  80 THEN 1
    WHEN message.length < 160 THEN 2
    ELSE                           3
  END AS lengthCategory,
  count(message) AS messageCount,
  sum(message.length) / to_float(count(message)) AS averageMessageLength,
  sum(message.length) AS sumMessageLength
RETURN
  year,
  isComment,
  lengthCategory,
  messageCount,
  averageMessageLength,
  sumMessageLength,
  messageCount / totalMessageCount AS percentageOfMessages
ORDER BY
  year DESC,
  isComment ASC,
  lengthCategory ASC
