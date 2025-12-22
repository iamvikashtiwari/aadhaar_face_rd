package com.example.aadhaar_face_rd

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class AadhaarFaceRdPlugin :
  FlutterPlugin,
  MethodChannel.MethodCallHandler,
  ActivityAware {

  private lateinit var channel: MethodChannel
  private var activity: Activity? = null
  private val REQUEST_CODE = 999

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "facerd_channel")
    channel.setMethodCallHandler(this)
  }

  /** Check if Aadhaar FaceRD app is installed */
  private fun isFaceRDInstalled(): Boolean {
    val act = activity ?: return false
    return try {
      act.packageManager.getPackageInfo(
        "in.gov.uidai.facerd",
        0
      )
      true
    } catch (e: Exception) {
      false
    }
  }


  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {

      "isFaceRDInstalled" -> {
        result.success(isFaceRDInstalled())
      }

      "launchFaceRD" -> {
        val xml = call.argument<String>("xml") ?: ""

        if (!isFaceRDInstalled()) {
          result.error(
            "FACE_RD_NOT_INSTALLED",
            "Aadhaar FaceRD app is not installed",
            null
          )
          return
        }

        val act = activity
        if (act == null) {
          result.error(
            "NO_ACTIVITY",
            "No active Activity to launch FaceRD",
            null
          )
          return
        }

        val intent = Intent("in.gov.uidai.rdservice.face.CAPTURE")
        intent.putExtra("request", xml)
        act.startActivityForResult(intent, REQUEST_CODE)
        result.success(true)
      }

      else -> result.notImplemented()
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity

    binding.addActivityResultListener { requestCode, _, data ->
      if (requestCode == REQUEST_CODE) {
        val resp = data?.getStringExtra("response")
        channel.invokeMethod("facerdResponse", resp)
        true
      } else {
        false
      }
    }
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
