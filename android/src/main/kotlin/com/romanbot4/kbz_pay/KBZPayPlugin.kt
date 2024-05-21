package com.romanbot4.kbz_pay

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import com.kbzbank.payment.KBZPay
import com.romanbot4.kbz_pay.entities.StartPayRequestEntity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** KBZPayPlugin */
class KBZPayPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "kbz_pay")
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(activityBinding: ActivityPluginBinding) {
        activity = activityBinding.activity
    }

    override fun onReattachedToActivityForConfigChanges(activityBinding: ActivityPluginBinding) {
        activity = activityBinding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "startPay") {
            val request = StartPayRequestEntity.parse(call.arguments as Map<String, Any>)
            startPay(
                request.orderInfo,
                request.sign,
                request.signType,
            )
        } else {
            result.notImplemented()
        }
    }


    private fun startPay(
        orderInfo: String,
        sign: String,
        signType: String,
    ) {
        KBZPay.startPay(
            activity,
            orderInfo,
            sign,
            signType,
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
