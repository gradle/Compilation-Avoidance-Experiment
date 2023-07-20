# Compilation Avoidance Performance Experiments

This project contains the experimental project used to generate results in the [Gradle's Approach to Faster Compilation](https://blog.gradle.org/gradles-approach-to-faster-compilation) blog post.
It is a synthetic build generated by modifying Gradle's own performance tests that compares Gradle's Java compilation avoidance approach with the Header Jars approach.
It contains 1000 subprojects, each with 10 source files, in order to be representative of a typical Bazel project's structure, yet still easily manageable in an IDE.

There are transitive implementation dependencies between the subprojects, for example, the class `Production0` defined in `project0` is used in every other subproject with a project number evenly divisible by 4.  
For example the `project4` project contains the class `Production41`, with the code:

```java
    private Production0 property0 = new Production0();

    public Production0 getProperty0() {
        return property0;
    }

    public void setProperty0(Production0 value) {
        property0 = value;
    }

    private String property1 = property0.getProperty1();
```

## Viewing the Results
Example results are provided in the `/results` directory.
These results were obtained using Gradle 8.2.1, Gradle 8.3-rc-1, and Bazel 6.2.1 on an Apple M2 Max MacBook Pro with 64 GB running macOS 13.4.1 and the Temurin 17.0.7 JDK.

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
   - For example:`python3 fix-bench-csvs.py results/abiChange/bazel/benchmark.csv results/abiChange/gradle-8.2.1/benchmark.csv results/abiChange/gradle-8.3-RC-1/benchmark.csv results/nonAbiChange/bazel/benchmark.csv results/nonAbiChange/gradle-8.2.1/benchmark.csv results/nonAbiChange/gradle-8.3-RC-1/benchmark.csv` run from the project root directory will create a file named `data.csv` with the output in that directory.

## Variations

Comment or uncomment lines in the `gradle.properties` file to run variations of the experiment using or disabling different Gradle features.
