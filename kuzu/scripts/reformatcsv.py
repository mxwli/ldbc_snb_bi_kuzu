
import pandas as pd
import sys

csv = sys.argv[1]

header = open(csv, 'r').readline().replace('\n','').split('|')
skipFlag = True
for item in header:
	if item.endswith('Id'):
		skipFlag = len(header) <= 2
		break
	elif item == 'speaks' or item == 'email':
		skipFlag = False
		break

if skipFlag:
	print('skipping ' + csv + ' reformatting')
	exit(0)

df = pd.read_csv(csv, sep='\|', engine='python')
columns = df.columns.tolist()
columns = sorted(columns, key=lambda x: not x.endswith('Id'))
df = df[columns]

if 'speaks' in columns:
	df['speaks'] = df['speaks'].map(lambda x: '[' + x.replace(';',',') + ']')

if 'email' in columns:
	df['email'] = df['email'].map(lambda x: '[' + x.replace(';',',') + ']')

df.to_csv(path_or_buf=csv, sep='|', index=False)
