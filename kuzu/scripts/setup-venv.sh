
set -eu
set -o pipefail

python3 -m venv venv

source venv/bin/activate

pip install --pre kuzu
pip install pandas
pip install pyarrow
