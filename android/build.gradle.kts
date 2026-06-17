import org.gradle.api.file.Directory
import org.gradle.api.tasks.Delete

plugins {

    // =========================
    // 🔥 Firebase Google Services
    // 既存classpath版を使用
    // =========================
    id("com.google.gms.google-services") apply false
}

allprojects {

    repositories {

        google()

        mavenCentral()
    }
}


// =========================
// 🔥 Build Directory
// =========================
val newBuildDir: Directory =

    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()

rootProject.layout.buildDirectory
    .value(newBuildDir)


// =========================
// 🔥 Sub Projects
// =========================
subprojects {

    val newSubprojectBuildDir:
        Directory = newBuildDir.dir(
            project.name
        )

    project.layout.buildDirectory
        .value(newSubprojectBuildDir)
}

subprojects {

    project.evaluationDependsOn(
        ":app"
    )
}


// =========================
// 🔥 Clean Task
// =========================
tasks.register<Delete>(
    "clean"
) {

    delete(
        rootProject.layout.buildDirectory
    )
}