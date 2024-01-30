# LDBC SNB BI Kuzu/Cypher implementation

using composite-projected-fk csv, currently only tested on a Scale Factor of 1 using pregenerated datasets.

Project setup instructions:
1. Set your scale factor: `export SF=<desired scale factor>`
2. Set your CSV location: `export KUZU_CSV_DIR=<directory>`
3. run `scripts/decompress-gz.sh` to extract and format .csv files
4. run `scripts/load-database.sh` to load the database
5. run `scripts/benchmark.sh` to run the benchmark.

output can be found in `output/` directory. 
python virtual environment is set up and dependencies are installed automatically.

The current timeout threshold for each query is 100 seconds.


