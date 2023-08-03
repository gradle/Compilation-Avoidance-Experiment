#!/usr/bin/env groovy
@Grapes(
        @Grab(group='com.opencsv', module='opencsv', version='5.5')
)
import com.opencsv.CSVReader

if (args.length < 1) {
    println "Usage: script <path_to_comparison_csv> <path_to_output_file>"
    System.exit(1)
}

class Scenario {
    String name
    boolean isAbiChange
    boolean isConfigurationCache
    List<Double> times = []

    Scenario(String name) {
        this.name = name.capitalize()
        isAbiChange = !name.contains("nonAbiChange")
        isConfigurationCache = name.contains("with CC")
    }

    void addTime(double time) {
        times.add(time)
    }

    int avgTime() {
        return (times.sum() / times.size()) as int
    }

    String getToolName() {
        return name - " nonAbiChange" - " abiChange" - " with CC"
    }
}

private List<Scenario> loadScenarios(File input) {
    CSVReader reader = new CSVReader(new FileReader(input))
    List<String[]> lines = reader.readAll().findAll { it.size() > 0 }

    int numScenarios = lines[0].size() - 1
    int numIterations = lines.size() - 1

    List<Scenario> results = []
    for (int scenarioNum = 0; scenarioNum < numScenarios; scenarioNum++) {
        Scenario scenario = new Scenario(lines[0][scenarioNum + 1])
        for (int iteration = 0; iteration < numIterations; iteration++) {
            scenario.addTime(Double.parseDouble(lines[iteration + 1][scenarioNum + 1]))
        }
        results.add(scenario)
    }
    return results
}

private String buildHeaderRow(List<Scenario> scenarios) {
    List<String> toolNames = scenarios.collect { it.toolName }.unique().sort()
    return "['Scenario', ${toolNames.collect { "'" + it + "'"}.join(', ')}]"
}

private List<String> buildResultsRows(List<Scenario> scenarios) {
    String abiChanges = scenarios.findAll { it.isAbiChange }.collect { it.avgTime() }.join(', ')
    String nonAbiChanges = scenarios.findAll { !it.isAbiChange }.collect { it.avgTime() }.join(', ')
    return ["['ABI Change', $abiChanges]", "['Non-ABI Change', $nonAbiChanges]"]
}

String processData(File inputFile) {
    List<Scenario> scenarios = loadScenarios(inputFile)

    return """
var data = [
    ${buildHeaderRow(scenarios)},
    ${buildResultsRows(scenarios).join(",\n    ")}
];
"""
}

private void writeOutputFile(String result, File outputFile) {
    outputFile.parentFile.mkdirs()
    if (outputFile.exists()) {
        outputFile.delete()
    }
    outputFile.createNewFile()
    outputFile << "// Comparison data from ${args[0]}\n"
    outputFile << result
}

def result = processData(new File(args[0]))
writeOutputFile(result, new File(args[1]))

println result
