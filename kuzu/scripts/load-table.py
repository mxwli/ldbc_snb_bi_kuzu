import kuzu
import sys
import pandas as pd

# usage: python3 load-table.py <tablename> <table-type> <header> <csv files>
# will reorder the csv to fit for kuzu if the table is a relation



def reorderCsv(csv):
	df = pd.read_csv(csv, sep='\|', engine='python')
	columns = df.columns.tolist()
	columns = sorted(columns, key=lambda x: x[-2:] != 'Id')
	df = df[columns]
	df.to_csv(path_or_buf=csv, sep='|', index=False)

tableName, tableType, headerFile = sys.argv[1:4]
csvFiles = sys.argv[4:]

for i in csvFiles:
	reorderCsv(i)

schema = open(headerFile, 'r').readline().replace('\n','')


db = kuzu.Database('../database')
conn = kuzu.Connection(db)


conn.execute(f"CREATE {tableType} TABLE {tableName}({schema})")

csvFiles = str(csvFiles).replace('\'','\"')

conn.execute(f"COPY {tableName} FROM {str(csvFiles)} (HEADER=true, DELIM=\"|\")")

print("Loaded " + tableName)
