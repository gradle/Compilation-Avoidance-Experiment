#!/usr/bin/env groovy
@Grapes(
        @Grab(group='com.opencsv', module='opencsv', version='5.5')
)
import com.opencsv.CSVReader

if (args.length < 1) {
    println "Usage: script <path_to_comparison_csv>"
    System.exit(1)
}

String transformCSVFile(File input) {
    CSVReader reader = new CSVReader(new FileReader(input))
    List<String[]> lines = reader.readAll().findAll { it.size() > 0 }

    int numScenarios = lines[0].size() - 1
    int numIterations = lines.size() - 1

    String[] scenarioNames = lines[0][1..numScenarios]
    double[] avgTimes =  calcAvgScenarioTimes(numScenarios, numIterations, lines)

    def titleRow = "['Scenario', ${scenarioNames.collect { "'" + it + "'"} .join(', ')}]"
    def resultsRows = (0..<numScenarios).collect { scenario ->
        def scenarioName = scenarioNames[scenario]
        def avgTime = avgTimes[scenario]
        def row = "['$scenarioName', ${avgTime}]"
        return row
    }.join(',\n    ')

    return """
var data = [
    $titleRow,
    $resultsRows
];
"""
}

private int[] calcAvgScenarioTimes(int numScenarios, int numIterations, List<String[]> lines) {
    int[] avgTimes = new int[numScenarios]
    for (int scenario = 0; scenario < numScenarios; scenario++) {
        double total = 0.0
        for (int iteration = 0; iteration < numIterations; iteration++) {
            total += Double.parseDouble(lines[iteration + 1][scenario + 1])
        }
        avgTimes[scenario] = (total / (numIterations)) as int
    }
    return avgTimes
}

def comparisonCsvFile = new File(args[0])
var result = transformCSVFile(comparisonCsvFile)
println result