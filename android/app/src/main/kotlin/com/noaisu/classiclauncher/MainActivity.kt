package com.noaisu.classiclauncher

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.provider.Settings
import android.util.Log
import android.view.KeyEvent
import android.view.MotionEvent
import androidx.annotation.NonNull
import androidx.core.graphics.createBitmap
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.android.TransparencyMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.ByteArrayOutputStream


class MainActivity : FlutterActivity() {
    private val METHODCHANNEL = "com.noaisu.classicLauncher/app"
    private val EVENTCHANNEL = "com.noaisu.classicLauncher/input"
    private var eventSink: EventChannel.EventSink? = null
  override fun getRenderMode() = RenderMode.texture
  override fun getTransparencyMode() = TransparencyMode.transparent

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHODCHANNEL).setMethodCallHandler {
      call, result ->
      when(call.method){
        "getApps" -> {
          CoroutineScope(Dispatchers.Main).launch {
            val apps = getAppList(applicationContext)
            result.success(apps)
          }}

          "launchApp" -> {
              CoroutineScope(Dispatchers.Main).launch {
                  val packageName: String? = call.argument("packageName") as String?
                  if(packageName == null){
                      result.success(false)
                      return@launch
                  }


                 val success: Boolean = launchApp(packageName, applicationContext)
                  result.success(success)
              }}

          "launchMail" -> {
              CoroutineScope(Dispatchers.Main).launch {



                  val success: Boolean = launchMail(applicationContext)
                  result.success(success)
              }}

          "launchCamera" -> {
              CoroutineScope(Dispatchers.Main).launch {



                  val success: Boolean = launchCamera(applicationContext)
                  result.success(success)
              }}


         /* "getWallpaper" -> {
              CoroutineScope(Dispatchers.Main).launch {
                  val wallpaper = getWallPaper(applicationContext)
                  result.success(wallpaper)
              }}*/

        else -> {
          result.notImplemented()
        }
      }
    }


      EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENTCHANNEL).setStreamHandler(
          object : EventChannel.StreamHandler {
              override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                  eventSink = events
              }

              override fun onCancel(arguments: Any?) {
                  eventSink = null
              }
          }
      )
  }

    suspend fun launchApp(packageName: String, context: Context): Boolean {

        try {
        val pm = context.packageManager
        val intent = pm.getLaunchIntentForPackage(packageName)

        if (intent == null) {

            return false
        }

        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        applicationContext.startActivity(intent)
        return true } catch (exc: Exception) {}
        return false
    }

    suspend fun launchMail(context: Context): Boolean{
        try {
            val intent = Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:"))
            val resolveInfo = context.packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)
         val packageName: String? = resolveInfo?.activityInfo?.packageName
           if(packageName == null){
               return false}

            return launchApp(packageName, context)



        } catch (exc: Exception) {

                // handle exception
            }





        return false
    }

    suspend fun launchCamera(context: Context): Boolean{

        try {
            val imageCaptureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)

            val pm = context.packageManager
            val resolveInfo: ResolveInfo = pm.resolveActivity(imageCaptureIntent, 0) ?: throw Exception("Could not resolve activity!")
            val applicationInfo: ApplicationInfo =
                resolveInfo.activityInfo?.applicationInfo ?:
                resolveInfo.serviceInfo?.applicationInfo ?:
                resolveInfo.providerInfo?.applicationInfo ?: throw Exception("ApplicationInfo not found!")

            return launchApp(applicationInfo.packageName, context)
        }
        catch (exc: Exception) {
            // handle exception
        }
    return false
    }



suspend fun getAppList(context: Context): List<Map<String, Any?>> =
    withContext(Dispatchers.IO) {

        val pm: PackageManager = context.packageManager

  
        val intent = Intent(Intent.ACTION_MAIN, null).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
        }

        val launchableApps = pm.queryIntentActivities(intent, 0)
            .mapNotNull { resolveInfo ->
                val appInfo = resolveInfo.activityInfo.applicationInfo
                val packageName = appInfo.packageName

                try {
                    val appName = pm.getApplicationLabel(appInfo).toString()
                    val iconBytes = pm.getApplicationIcon(appInfo).toByteArray()
                    mapOf(
                        "packageName" to packageName,
                        "title" to appName,
                        "icon" to iconBytes
                    )
                } catch (e: Exception) {
                    null
                }
            }

        launchableApps.sortedBy { it["title"] as String } // optional alphabetical
    }


 //   @RequiresPermission(anyOf = ["android.permission.READ_WALLPAPER_INTERNAL", Manifest.permission.MANAGE_EXTERNAL_STORAGE])
 //   suspend fun getWallPaper(context: Context): ByteArray? {
//return null;
     //   return WallpaperManager.getInstance(context).drawable?.toByteArray();

 //   }


  private fun Drawable.toByteArray(): ByteArray {
    val bitmap = if (this is BitmapDrawable) {
      this.bitmap
    } else {
      val bmp = createBitmap(intrinsicWidth.coerceAtLeast(1), intrinsicHeight.coerceAtLeast(1))
      val canvas = Canvas(bmp)
      setBounds(0, 0, canvas.width, canvas.height)
      draw(canvas)
      bmp
    }

    val outputStream = ByteArrayOutputStream()
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
    return outputStream.toByteArray()
  }


private fun PackageManager.getInstalledPackagesCompat(flags: Long = 0L): List<PackageInfo> {
  return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
    getInstalledPackages(PackageManager.PackageInfoFlags.of(flags))
  } else {
    @Suppress("DEPRECATION")
    getInstalledPackages(flags.toInt())
  }
}


    override fun onKeyUp(keyCode: Int, event: KeyEvent): Boolean {
        val keyInfo = mapOf(
            "keyCode" to keyCode,
            "keyLabel" to event.displayLabel.toString(),
            "state" to "keyup"
        )
        eventSink?.success(keyInfo)
        return true
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        val keyInfo = mapOf(
            "keyCode" to keyCode,
            "keyLabel" to event.displayLabel.toString(),
            "state" to "keydown"
        )
        eventSink?.success(keyInfo)
        return true
    }

    override fun onGenericMotionEvent(event: MotionEvent?): Boolean {
        if(event == null) return super.onGenericMotionEvent(event)

        val actionStr = when(event.actionMasked) {
            MotionEvent.ACTION_HOVER_MOVE -> "HOVER_MOVE"
            MotionEvent.ACTION_SCROLL -> "SCROLL"
            MotionEvent.ACTION_MOVE -> "MOVE"
            MotionEvent.ACTION_DOWN -> "DOWN"
            MotionEvent.ACTION_UP -> "UP"
            MotionEvent.ACTION_BUTTON_PRESS -> "BUTTON_PRESS"
            MotionEvent.ACTION_BUTTON_RELEASE -> "BUTTON_RELEASE"
            else -> event.actionMasked.toString()
        }

        val info = """
        ===== MotionEvent =====
        action: $actionStr
        deviceId: ${event.deviceId}
        source: ${event.source}
        pointerCount: ${event.pointerCount}
        x/y: ${event.getX(0)}, ${event.getY(0)}
        pressure: ${event.getPressure(0)}
        axis values: 
            HORIZONTAL_SCROLL: ${event.getAxisValue(MotionEvent.AXIS_HSCROLL)}
            VERTICAL_SCROLL: ${event.getAxisValue(MotionEvent.AXIS_VSCROLL)}
            X: ${event.getAxisValue(MotionEvent.AXIS_X)}
            Y: ${event.getAxisValue(MotionEvent.AXIS_Y)}
            Z: ${event.getAxisValue(MotionEvent.AXIS_Z)}
    """.trimIndent()

        Log.d("USB_KEY_DEBUG", info)

        return super.onGenericMotionEvent(event)
    }


}
