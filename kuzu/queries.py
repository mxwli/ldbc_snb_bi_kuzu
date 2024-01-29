import datetime
import time
import re
import json
import sys
sys.path.append('../common')
from result_mapping import result_mapping

'''
This file was taken from the prewritten neo4j benchmark, and was modified to fit Kuzu
'''

def cast_parameter_to_kuzu_input(value, parameter_type):
    if parameter_type == "ID[]" or parameter_type == "INT[]" or parameter_type == "INT32[]" or parameter_type == "INT64[]":
        return '['+','.join([int(x) for x in value.split(";")])+']'
    elif parameter_type == "ID" or parameter_type == "INT" or parameter_type == "INT32" or parameter_type == "INT64":
        return int(value)
    elif parameter_type == "STRING[]":
        return '['+','.join([f'\"{x}\"' for x in value.split(";")])+']'
    elif parameter_type == "STRING":
        return f'\"{value}\"'
    elif parameter_type == "DATETIME":
        dt = datetime.datetime.strptime(value, '%Y-%m-%dT%H:%M:%S.%f+00:00')
        dt = datetime.datetime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second, dt.microsecond*1000, tzinfo=datetime.timezone.utc)
        return  f"timestamp(\"{datetime.datetime.strftime(dt, '%Y-%m-%dT%H:%M:%S.%f')[:-3]}+00:00\")"
    elif parameter_type == "DATE":
        dt = datetime.datetime.strptime(value, '%Y-%m-%d')
        dt = datetime.datetime(dt.year, dt.month, dt.day, tzinfo=datetime.timezone.utc)
        return f"date(\"{datetime.datetime.strftime(dt, '%Y-%m-%d')}\")"
    else:
        raise ValueError(f"Parameter type {parameter_type} not found")

def run_query(connection, query_num, query_variant, query_spec, query_parameters, test):
    if test:
        print(f'Q{query_variant}: {query_parameters}')

    start = time.time()
    full_query = query_spec
    #full_query = re.sub(' +', ' ', query_spec.replace('\n', ' '))
    for key in query_parameters:
        full_query = full_query.replace('$'+key, str(query_parameters[key]))
    
    results = None

    try:
        results = connection.execute(full_query)
    except RuntimeError as ex:
        end = time.time()
        duration = end - start
        print(f"Runtime Error caught! {ex}")
        return ([f"Runtime Error: {ex}"], 'N/A')
        

    resultsList = []
    while results.has_next():
        resultsList.append(results.get_next())
    end = time.time()
    duration = end - start
    if test:
        print(f"-> {duration:.4f} seconds")
        print(f"-> {resultsList}")
    return (resultsList, duration)


def run_queries(query_variants, parameter_csvs, connection, sf, batch_id, batch_type, test, pgtuning, timings_file, results_file):
    start = time.time()

    for query_variant in query_variants:
        query_num = int(re.sub("[^0-9]", "", query_variant))
        query_subvariant = re.sub("[^ab]", "", query_variant)

        print(f"========================= Q {query_num:02d}{query_subvariant.rjust(1)} =========================")
        query_file = open(f'queries/bi-{query_num}.cypher', 'r')
        query_spec = query_file.read()
        query_file.close()

        parameters_csv = parameter_csvs[query_variant]

        i = 0
        for query_parameters in parameters_csv:
            i = i + 1

            query_parameters_converted = {k.split(":")[0]: cast_parameter_to_kuzu_input(v, k.split(":")[1]) for k, v in query_parameters.items()}

            query_parameters_split = {k.split(":")[0]: v for k, v in query_parameters.items()}
            query_parameters_in_order = json.dumps(query_parameters_split)

            (results, duration) = run_query(connection, query_num, query_variant, query_spec, query_parameters_converted, test)

            timings_file.write(f"Kuzu|{sf}|{batch_id}|{batch_type}|{query_variant}|{query_parameters_in_order}|{duration}\n")
            timings_file.flush()
            results_file.write(f"{query_num}|{query_variant}|{query_parameters_in_order}|{results}\n")
            results_file.flush()

            # - test run: 1 query
            # - regular run: 30 queries
            # - paramgen tuning: 100 queries
            if (test) or (not pgtuning and i == 30) or (pgtuning and i == 100):
                break

    return time.time() - start

'''

def write_query_fun(tx, query_spec):
    tx.run(query_spec, {})

def run_precomputations(sf, query_variants, session, batch_date, batch_type, timings_file):
    if "19a" in query_variants or "19b" in query_variants:
        start = time.time()
        print("Creating graph (precomputing weights) for Q19")
        session.write_transaction(write_query_fun, open(f'queries/bi-19-drop-graph.cypher', 'r').read())
        session.write_transaction(write_query_fun, open(f'queries/bi-19-create-graph.cypher', 'r').read())
        end = time.time()
        duration = end - start
        timings_file.write(f"Kuzu|{sf}|{batch_date}|{batch_type}|q19precomputation||{duration}\n")

    if "20a" in query_variants or "20b" in query_variants:
        start = time.time()
        print("Creating graph (precomputing weights) for Q20")
        session.write_transaction(write_query_fun, open(f'queries/bi-20-drop-graph.cypher', 'r').read())
        session.write_transaction(write_query_fun, open(f'queries/bi-20-create-graph.cypher', 'r').read())
        end = time.time()
        duration = end - start
        timings_file.write(f"Kuzu|{sf}|{batch_date}|{batch_type}|q20precomputation||{duration}\n")

precomputations (and queries pertaining to them) are disabled for now
'''
