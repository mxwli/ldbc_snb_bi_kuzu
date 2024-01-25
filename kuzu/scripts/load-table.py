import kuzu
import sys

# usage: python3 load-table.py <tablename> <table-type> <csv files>
# will reorder the csv to fit for kuzu if the table is a relation


tableName, tableType = sys.argv[1:3]
csvFiles = sys.argv[3:]

db = kuzu.Database('database')
conn = kuzu.Connection(db)

csvFiles = str(csvFiles).replace('\'','\"')

conn.execute(f"COPY {tableName} FROM {str(csvFiles)} (HEADER=true, DELIM=\"|\")")

print("Loaded " + tableName)
