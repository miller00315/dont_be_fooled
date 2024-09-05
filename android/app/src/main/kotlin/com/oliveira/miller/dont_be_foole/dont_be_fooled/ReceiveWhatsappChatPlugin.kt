package com.oliveira.miller.dont_be_foole.dont_be_fooled

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private val CHANNEL: String = "com.whatsapp.chat/chat"
val TITLE: String = "title"
val TEXT: String = "text"
val PATH = "path"
val TYPE = "type"
val PACKAGE = "package"
val IS_MULTIPLE = "is_multiple"

class ReceiveWhatsappChatPlugin: FlutterPlugin, MethodChannel.MethodCallHandler{

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        TODO("Not yet implemented")
    }
}