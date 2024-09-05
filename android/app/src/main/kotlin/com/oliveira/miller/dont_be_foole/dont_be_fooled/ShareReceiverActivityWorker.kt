package com.oliveira.miller.dont_be_foole.dont_be_fooled

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import java.util.function.Supplier

class ShareReceiverActivityWorker: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val intent: Intent = intent

        val action: String? = intent.action

        val type: String? = intent.type

        if((Intent.ACTION_SEND == action || Intent.ACTION_SEND_MULTIPLE == action) && type != null)
        {
            println(intent.extras)
            passShareToMainActivity(intent)
        } else {
            finish()
        }
    }

    private fun passShareToMainActivity(intent: Intent) {
        val launchIntent: Intent? = context.packageManager.getLaunchIntentForPackage(packageName)

        launchIntent?.let {
            val text: ArrayList<String>?  =
                intent.getStringExtra(Intent.EXTRA_TEXT)?.split(' ') as ArrayList<String>?

            val stream = intent.getParcelableExtra(Intent.EXTRA_STREAM, ArrayList<Uri>()::class.java)

            launchIntent.setAction(intent.action)
            launchIntent.setType(intent.type)
            launchIntent.putExtra(Intent.EXTRA_SUBJECT, intent.getStringExtra(Intent.EXTRA_SUBJECT))
            launchIntent.putExtra(Intent.EXTRA_TEXT, text)
            launchIntent.putExtra(Intent.EXTRA_STREAM, stream)

            startActivity(launchIntent)

            finish()
        }
    }

}