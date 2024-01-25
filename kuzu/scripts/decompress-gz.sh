
set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

source scripts/setup-venv.sh

unzip_and_reformat() {
	gzip -dfk $1
	python3 reformatcsv.py "${1%.csv.gz}.csv"
	echo "decompressed and reformatted $1"
}
export -f unzip_and_reformat

find ${KUZU_CSV_DIR} -name *.csv.gz -type f | xargs -n 1 -P $(nproc) -I {} bash -c 'unzip_and_reformat "{}"' 
