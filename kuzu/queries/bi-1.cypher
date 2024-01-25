// Q1. Posting summary
/*
:params { datetime: datetime('2011-12-01T00:00:00.000') }
*/
MATCH (Message:Post:Comment)
WHERE Message.creationDate < $datetime
WITH count(Message) AS totalMessageCount
MATCH (Message:Post:Comment)
WITH Message.creationDate AS date,
     LABEL(Message) = "Comment" AS isComment,
     size(Message.content) AS messageLength,
     CASE
      WHEN size(Message.content) <  40 THEN 0
      WHEN size(Message.content) <  80 THEN 1
      WHEN size(Message.content) < 160 THEN 2
      ELSE                                  3
     END
     AS lengthCategory,
     count(*) AS messageCount,
     totalMessageCount
WHERE date < $datetime
RETURN date_part('year', date) AS year,
     isComment,
     lengthCategory,
     messageCount,
     avg(messageLength) AS averageMessagelength,
     sum(messageLength) AS sumMessageLength,
     to_float(messageCount) / totalMessageCount AS percentageOfMessages
