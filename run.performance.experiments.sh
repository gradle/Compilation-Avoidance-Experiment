#!/bin/bash

rm -rf results
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --bazel --output-dir results/nonAbiChange/bazel
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --bazel --output-dir results/abiChange/bazel
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --gradle-version 8.2.1 --output-dir results/nonAbiChange/gradle-8.2.1
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --gradle-version 8.2.1 --output-dir results/abiChange/gradle-8.2.1
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios nonAbiChange --gradle-version 8.3-20230712030806+0000 --output-dir results/nonAbiChange/gradle-8.3-RC1
gradle-profiler --benchmark --warmups 5 --iterations 10 --scenario-file performance.scenarios abiChange --gradle-version 8.3-20230712030806+0000 --output-dir results/abiChange/gradle-8.3-RC1
