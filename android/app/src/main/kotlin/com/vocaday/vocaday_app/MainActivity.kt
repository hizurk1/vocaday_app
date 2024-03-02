package com.vocaday.vocaday_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone

class MainActivity: FlutterActivity() {
     private val CHANNEL = "com.vocaday.vocaday_app/notification_service"

     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
         super.configureFlutterEngine(flutterEngine)
         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                 call, result ->
            if (call.method == "getLocalTimeZone") {
                 val timeZone = TimeZone.getDefault()
                 result.success(timeZone.id)
            }
         }
     }
}
