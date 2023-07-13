#!/usr/bin/env python3

from collections import defaultdict
import csv
import argparse
from typing import DefaultDict, Dict, List


def get_kv(row: List[str], expected_key: str) -> str:
    if row[0] != expected_key:
        raise ValueError(f"Expected key {expected_key} but got {row[0]}")
    return row[1]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("csvs", metavar="CSV", type=argparse.FileType("r"), nargs="+")

    args = parser.parse_args()

    # Collect the times from each CSV file
    # Each CSV is like:
    # scenario,<name>
    # version,<name>
    # tasks,<entry>
    # value,<desc>
    # <index>,<time>
    #
    # We only care about scenario, version, and <index>,<time> lines
    # The goal output is:
    # Iteration,<version+scenario>,<version+scenario>,...
    # <index>,<time>,<time>,...
    tool_and_scenario: List[str] = []
    times: DefaultDict[str, List[int]] = defaultdict(list)
    for csv_file in args.csvs:
        with csv_file:
            reader = csv.reader(csv_file, dialect="unix")
            scenario = get_kv(next(reader), "scenario")
            version = get_kv(next(reader), "version")
            get_kv(next(reader), "tasks")
            get_kv(next(reader), "value")
            tool_and_scenario.append(f"{version} {scenario}")
            for row in reader:
                # Drop warm-up builds
                index = row[0]
                if index.startswith("warm-up"):
                    continue
                index = index.replace("measured build #", "")
                time = float(row[1])
                times[index].append(time)

    # Write the output
    with open("data.csv", "w") as out:
        writer = csv.writer(out, dialect="unix", quoting=csv.QUOTE_MINIMAL)
        writer.writerow(["Iteration"] + tool_and_scenario)
        for index, times in times.items():
            writer.writerow([index] + times)


if __name__ == "__main__":
    main()
