
set -eu
set -o pipefail

for output in $(find ${KUZU_CSV_DIR} -name *.csv.gz -type f)
do
	gzip -df $output
done

