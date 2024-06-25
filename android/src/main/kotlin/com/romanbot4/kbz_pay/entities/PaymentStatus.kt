package com.romanbot4.kbz_pay.entities

data class PaymentStatus (
        val status: String,
        val message: String
) {
    fun toJson() : Map<String, Any> {
        return hashMapOf(
                "status" to status,
                "message" to message,
        )
    }

    companion object {
        fun fail(message: String) : PaymentStatus {
            return PaymentStatus(
                    status = "fail",
                    message = message,
            )
        }

        fun success(message: String) : PaymentStatus {
            return PaymentStatus(
                    status = "success",
                    message = message
            )
        }
    }
}