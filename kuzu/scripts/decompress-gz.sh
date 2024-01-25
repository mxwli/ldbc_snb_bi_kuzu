
set -eu
set -o pipefail

source setup-venv.sh

for output in $(find ${KUZU_CSV_DIR} -name *.csv.gz -type f)
do
	gzip -dfk $output
	python3 reformatcsv.py "${output%.csv.gz}.csv"
	echo "decompressed and reformatted ${output%.csv.gz}"
done

