#!/bin/bash

# Clear all results
rm -rf results
rm -rf comparisons
mkdir comparisons

# Run performance experiments with profiles
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --bazel --output-dir results/nonAbiChange/bazel
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --bazel --output-dir results/abiChange/bazel
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --gradle-version 8.0 --output-dir results/nonAbiChange/gradle-8.0
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --gradle-version 8.0 --output-dir results/abiChange/gradle-8.0

# Enable configuration cache (stable as of Gradle 8.1)
sed -i '' 's/#org.gradle.configuration-cache=true/org.gradle.configuration-cache=true/' gradle.properties

gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --gradle-version 8.2.1 --output-dir results/nonAbiChange/gradle-8.2.1
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --gradle-version 8.2.1 --output-dir results/abiChange/gradle-8.2.1
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --gradle-version 8.3-rc-3 --output-dir results/nonAbiChange/gradle-8.3-rc-3
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --gradle-version 8.3-rc-3 --output-dir results/abiChange/gradle-8.3-rc-3

# Reset configuration cache
sed -i '' 's/org.gradle.configuration-cache=true/#org.gradle.configuration-cache=true/' gradle.properties

# Process results into comparisons
python3 fix-bench-csvs.py comparisons/bazel-and-all-gradle.csv results/abiChange/bazel/benchmark.csv results/nonAbiChange/bazel/benchmark.csv results/abiChange/gradle-8.0/benchmark.csv results/nonAbiChange/gradle-8.0/benchmark.csv results/abiChange/gradle-8.2.1/benchmark.csv results/nonAbiChange/gradle-8.2.1/benchmark.csv results/abiChange/gradle-8.3-rc-3/benchmark.csv results/nonAbiChange/gradle-8.3-RC-3/benchmark.csv

./chart-averages.groovy comparisons/bazel-and-all-gradle.csv comparisons/bazel-and-all-gradle.js
