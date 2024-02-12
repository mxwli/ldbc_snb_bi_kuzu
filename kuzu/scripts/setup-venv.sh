
set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

python3 -m venv venv

source venv/bin/activate

pip install kuzu==0.2.0
pip install pandas
pip install pyarrow
