package br.com.odawara.haven_app

import android.app.WallpaperManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build.VERSION_CODES
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "br.com.odawara/wallpaper"

    @RequiresApi(VERSION_CODES.N)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            when (call.method) {
                "setWallpaper" -> {
                    setWallpaperByPath(call.argument("path")!!)
                    result.success("Wallpaper set successfully")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun setWallpaperByPath(path: String) {
        val imgFile = File(path)
        val bitmap: Bitmap = BitmapFactory.decodeFile(imgFile.absolutePath)
        var wm: WallpaperManager? = null
        wm = WallpaperManager.getInstance(this)
        wm.setBitmap(bitmap)
    }

}
