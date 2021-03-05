package tech.garande.covid_app

// import io.flutter.app.FlutterApplication
import android.app.Application

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        registerActivityLifecycleCallbacks(LifecycleDetector.activityLifecycleCallbacks)
    }
}