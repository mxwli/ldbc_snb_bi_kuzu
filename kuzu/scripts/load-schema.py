import kuzu
import sys

# usage: python3 load-schema.py
# will set up schemas

db = kuzu.Database('../database')
conn = kuzu.Connection(db)

for line in open('../schemas/schema.cypher', 'r'):
	conn.execute(line)

results = conn.execute('CALL SHOW_TABLES() RETURN *')

#while results.has_next():
#	print(results.get_next())
