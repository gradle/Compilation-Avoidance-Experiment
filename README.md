# Header Jars Performance Experiments

This project contains an experimental project (with many subprojects) used to generate results in the [Gradle's Approach to Faster Compilation](https://blog.gradle.org/gradles-approach-to-faster-compilation) blog post.
The post compares Gradle's Java compilation avoidance approach with the Header Jars approach.

## Viewing the Results
Example results are provided in the `/results` directory.
These results were obtained using Gradle 8.2.1, a pre-release version of Gradle 8.3, and Bazel 6.2.1 on an Apple M2 Max MacBook Pro with 64 GB running macOS 13.4.1.

## Running the Benchmarks
These instructions explain how to reproduce the results used in this blog post.

> Due to environmental variations your exact timings may differ. 
> The overall analysis should still apply.

1. Download this repository.
1. Install Gradle Profiler using the instructions [here](https://github.com/gradle/gradle-profiler).
1. Install Bazel using the instructions [here](https://bazel.build/install).
1. Execute the `run.performance.experiments.sh` script from the project root directory.
1. Results will be written to the `/results` directory (existing results will be deleted).  The html graphs can be viewed directly, or the CSV files can be used to generate your own graphs.
1. (Optionally) To assemble a single CSV file containing multiple results in a format suitable for easy comparisons as in the graphics included in the blog post, provide a list of result CSV file to the `fix-bench-csvs.py` python script.
   - For example:`python3 fix-bench-csvs.py results/abiChange/bazel/benchmark.csv results/abiChange/gradle-8.2.1/benchmark.csv results/abiChange/gradle-8.3-RC1/benchmark.csv results/nonAbiChange/bazel/benchmark.csv results/nonAbiChange/gradle-8.2.1/benchmark.csv results/nonAbiChange/gradle-8.3-RC1/benchmark.csv` run from the project root directory will create a file named `data.csv` with the output in that directory.
