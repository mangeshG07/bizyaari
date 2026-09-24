
import com.android.build.api.dsl.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}


// flutter_inappwebview_android 1.1.3 enables R8 for its own release AAR.
// Its FlutterPlugin entry class is discovered by reflection, so R8 removes it.
// Once that class is missing, GeneratedPluginRegistrant stops and no Android
// plugins (including SharedPreferences and local notifications) are registered.
subprojects {
    if (name == "flutter_inappwebview_android") {
        afterEvaluate {
            extensions.configure<LibraryExtension>("android") {
                buildTypes.getByName("release") {
                    isMinifyEnabled = false
                }
            }
        }
    }
}



tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
