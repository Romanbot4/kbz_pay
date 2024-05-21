package com.romanbot4.kbz_pay.entities

data class StartPayRequestEntity(
    val orderInfo: String,
    val sign: String,
    val signType: String,
) {
    companion object {
        fun parse(
            map: Map<String, Any>
        ): StartPayRequestEntity {
            return StartPayRequestEntity(
                orderInfo = map["orderInfo"] as String,
                sign = map["sign"] as String,
                signType = map["signType"] as String,
            )
        }

    }
}