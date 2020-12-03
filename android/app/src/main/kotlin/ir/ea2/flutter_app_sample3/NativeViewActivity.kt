package ir.ea2.flutter_app_sample3
import android.os.Bundle
import android.util.Log
import android.widget.Button
import ir.ea2.flutter_app_sample3.MainActivity
import ir.ea2.flutter_app_sample3.R
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class NativeViewActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val channel = MethodChannel(flutterView, MainActivity.CHANNEL)

        setContentView(R.layout.layout)
        findViewById<Button>(R.id.button).setOnClickListener {
            channel.invokeMethod("message", "Hello from Android native host")
        }
    }
}