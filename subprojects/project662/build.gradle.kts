plugins {

            id("java-library")

id("eclipse")
id("idea")
}

group = "org.gradle.test.performance"
version = "2.0"

repositories {

            maven {
                name = "MAVEN_CENTRAL_MIRROR"
                url = uri("https://repo.maven.apache.org/maven2/")
            }

}


    dependencies {

            "api"(libs.commonsLang)
    "api"(libs.commonsHttpClient)
    "api"(libs.commonsCodec)
    "api"(libs.jclOverSlf4j)
            "implementation"(libs.reflectasm)
            "testImplementation"(libs.junit)

            "api"(project(":subprojects:project659"))
    "implementation"(project(":subprojects:project660"))
    "implementation"(project(":subprojects:project661"))

    }


dependencies{

}



val compilerMemory: String by project
val testRunnerMemory: String by project
val testForkEvery: String by project

tasks.withType<JavaCompile> {
    options.isFork = true
    options.isIncremental = true
    options.forkOptions.memoryInitialSize = compilerMemory
    options.forkOptions.memoryMaximumSize = compilerMemory
}
tasks.withType<GroovyCompile> {
    options.isFork = true
    options.isIncremental = true
    options.forkOptions.memoryInitialSize = compilerMemory
    options.forkOptions.memoryMaximumSize = compilerMemory
}

tasks.withType<Test> {

    minHeapSize = testRunnerMemory
    maxHeapSize = testRunnerMemory
    maxParallelForks = 1
    setForkEvery(testForkEvery.toLong())

    if (!JavaVersion.current().isJava8Compatible) {
        jvmArgs("-XX:MaxPermSize=512m")
    }
    jvmArgs("-XX:+HeapDumpOnOutOfMemoryError")
}

task<DependencyReportTask>("dependencyReport") {
    outputs.upToDateWhen { false }
    outputFile = buildDir.resolve("dependencies.txt")
}