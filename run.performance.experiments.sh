#!/bin/bash

# Clear all results
rm -rf results
rm -rf comparisons

# Run performance experiments with profiles
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --bazel --output-dir results/nonAbiChange/bazel
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --bazel --output-dir results/abiChange/bazel
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --gradle-version 8.2.1 --output-dir results/nonAbiChange/gradle-8.2.1
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --gradle-version 8.2.1 --output-dir results/abiChange/gradle-8.2.1
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --gradle-version 8.3-rc-1 --output-dir results/nonAbiChange/gradle-8.3-RC-1
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --gradle-version 8.3-rc-1 --output-dir results/abiChange/gradle-8.3-RC-1

# Enable configuration cache
sed -i '' 's/#org.gradle.configuration-cache=true/org.gradle.configuration-cache=true/' gradle.properties

# Run experiments with configuration cache
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --gradle-version 8.3-rc-1 --output-dir results/nonAbiChange/gradle-8.3-RC-1-with-cc
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --gradle-version 8.3-rc-1 --output-dir results/abiChange/gradle-8.3-RC-1-with-cc

# Disable configuration cache
sed -i '' 's/org.gradle.configuration-cache=true/#org.gradle.configuration-cache=true/' gradle.properties

# Label scenario name in CC results to mark CC usage
sed -i '' 's/nonAbiChange/nonAbiChange with CC/' results/nonAbiChange/gradle-8.3-RC-1-with-cc/benchmark.csv
sed -i '' 's/abiChange/abiChange with CC/' results/abiChange/gradle-8.3-RC-1-with-cc/benchmark.csv

# Process results into comparisons
python3 fix-bench-csvs.py comparisons/bazel-and-gradle-8.2.1.csv results/abiChange/bazel/benchmark.csv results/abiChange/gradle-8.2.1/benchmark.csv results/nonAbiChange/bazel/benchmark.csv results/nonAbiChange/gradle-8.2.1/benchmark.csv
python3 fix-bench-csvs.py comparisons/bazel-and-gradle-8.3-RC-1.csv results/abiChange/bazel/benchmark.csv results/abiChange/gradle-8.3-RC-1/benchmark.csv results/nonAbiChange/bazel/benchmark.csv results/nonAbiChange/gradle-8.3-RC-1/benchmark.csv
python3 fix-bench-csvs.py comparisons/gradle-8.3-RC-1-with-cc.csv results/abiChange/gradle-8.3-RC-1/benchmark.csv results/abiChange/gradle-8.3-RC-1-with-cc/benchmark.csv results/nonAbiChange/gradle-8.3-RC-1/benchmark.csv results/nonAbiChange/gradle-8.3-RC-1-with-cc/benchmark.csv
