package com.kbzbank.payment.sdk.callback

import android.app.Activity
import android.os.Bundle
import android.os.PersistableBundle
import com.kbzbank.payment.KBZPay
import com.romanbot4.kbz_pay.KBZPayPlugin
import com.romanbot4.kbz_pay.entities.PaymentStatus
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterMain


class CallbackResultActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState);
        println("Romanbot4 - CallbackResultActivity created")
        val result = intent.getIntExtra(KBZPay.EXTRA_RESULT, 0)
        if(result == KBZPay.COMPLETED) {
            println("Romanbot4 - CallbackResultActivity payment success")
            success()
        } else  {
            println("Romanbot4 - CallbackResultActivity payment fail")
            val failMsg = intent.getStringExtra(KBZPay.EXTRA_FAIL_MSG)
            fail(failMsg ?: "KBZ transaction failed")
        }
        finish()
    }

    private fun success() {
        sendResult(PaymentStatus.success("KBZ transaction success"))
    }

    private  fun fail(message: String) {
        sendResult(PaymentStatus.fail(message))
    }

    private fun sendResult(status: PaymentStatus) {
        val loader = FlutterLoader()
        loader.startInitialization(this)
        KBZPayPlugin.sendPaymentStatus(status)
    }

    private fun sendResultToFlutter(status: PaymentStatus) {
        FlutterMain.startInitialization(this) // Ensure Flutter engine is initialized
        val resultData: MutableMap<String, Any> = HashMap()
        KBZPayPlugin.sendPaymentStatus(status)
        KBZPayPlugin.callbackChannel.invokeMethod("paymentResult", resultData)
    }
}