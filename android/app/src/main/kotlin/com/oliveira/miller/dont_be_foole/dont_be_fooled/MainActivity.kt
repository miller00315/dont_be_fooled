package com.oliveira.miller.dont_be_foole.dont_be_fooled

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

import java.io.BufferedReader
import java.io.ByteArrayOutputStream
import java.io.InputStream
import java.io.InputStreamReader

import  com.oliveira.miller.dont_be_foole.dont_be_fooled.ReceiveWhatsappChatPlugin
import io.flutter.plugin.common.EventChannel.StreamHandler

class MainActivity: FlutterActivity() {
    private val stream: String = "plugins.flutter.io/receiveshare"
    private val channel: String = "com.whatsapp.chat/chat";
    private var eventSink: EventChannel.EventSink? = null;
    private var ignoring: Boolean = false
    private var backlog: ArrayList<Intent> = ArrayList()
    private var inited: Boolean = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
          call, result ->
            if(call.method.equals("openwhatsapp")) {
                openWhatsapp()
            } else if(call.method.equals("analyze")) {
                val url: String? = call.argument<String>("data");

                val arrayList: ArrayList<String> = ArrayList()

                url?.let {
                    val students: Uri = Uri.parse(url)

                    val cursor = context.contentResolver.query(students, null, null, null, null)

                    cursor?.let {
                        try {
                            val openInputStream: InputStream? = context.contentResolver.openInputStream(students);

                            openInputStream?.let {
                                val bufferReader = BufferedReader(InputStreamReader(openInputStream))

                                cursor.moveToFirst();

                                arrayList.add(cursor.getString(0))

                                bufferReader.useLines {
                                    lines -> lines.forEach {
                                        arrayList.add(it)
                                    }
                                }

                                openInputStream.close();
                            }

                        } catch (e: Exception) {
                            Log.i("error", e.toString())
                        }

                        cursor.close()
                    }

                }

                result.success(arrayList);

            } else if(call.method.equals("getImage")) {
                val url: String? = call.argument<String>("data")

                url?.let {
                    val students: Uri = Uri.parse(url)
                    try {
                        val openInputStream: InputStream? = context.contentResolver.openInputStream(students);


                        if(openInputStream != null) {

                            val buffer = ByteArrayOutputStream()

                            var nRead: Int?

                            val data = ByteArray(16384)

                            while (true) {
                                nRead = openInputStream.read(data, 0, data.size)

                                if(nRead == -1) {
                                    break
                                }

                                buffer.write(data, 0, nRead)
                            }

                            openInputStream.close();

                            result.success(buffer.toByteArray())
                        } else {
                            result.success(null)
                        }
                    } catch (e: Exception) {
                        result.success(null)
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        handleIntent(intent)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if(!inited) {
            flutterEngine?.dartExecutor?.binaryMessenger?.let { init(it, this) }
        }
    }

    private fun init(flutterView: BinaryMessenger, context: Context) {
       context.startActivity(Intent(context, ShareReceiverActivityWorker::class.java))

        EventChannel(flutterView, stream).setStreamHandler(object: StreamHandler{
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
                ignoring = false

                for(i in 0 until backlog.size) {
                    backlog.removeAt(i)
                }
            }

            override fun onCancel(arguments: Any?) {
                ignoring = true
                eventSink = null
            }
        })

        inited = true;

        handleIntent(intent)
    }

  private fun openWhatsapp() {
    try {
        val intent: Intent? = context.packageManager.getLaunchIntentForPackage("com.whatsapp")

        intent?.let { startActivity(intent) }
    } catch(e: Exception) {
        Toast.makeText(this, "Error\n$e", Toast.LENGTH_SHORT).show();
    }
  }

  private fun handleIntent(intent: Intent) {
      val action: String? = intent.action
      val type: String? = intent.type;

      if(Intent.ACTION_SEND == action && type != null) {
          val sharedTitle = intent.getStringExtra(Intent.EXTRA_SUBJECT)
          if("text/plain" == type) {

              sharedTitle?.let {

                  val sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)

                  if(eventSink != null) {
                      val params: HashMap<String, String> = HashMap()

                      params[TYPE] = type

                      sharedText?.let {
                          params[TEXT] = sharedText
                      }

                      if(sharedTitle.isNotEmpty()) {
                          params[TITLE] = sharedTitle
                      }

                      eventSink?.success(params);
                  } else if (!ignoring && !backlog.contains(intent)) {
                      backlog.add(intent)
                  } else { }
              }

          } else {
              sharedTitle?.let {
                  val sharedUri: Uri? = intent.getParcelableExtra(Intent.EXTRA_STREAM);

                  sharedUri?.let {

                      if(eventSink != null) {
                          val params: HashMap<String, String> = HashMap()

                          params[TYPE] = type
                          params[PATH] = sharedUri.toString()

                          if(sharedTitle.isNotEmpty()) {
                              params[TITLE] = sharedTitle
                          }

                          if(!intent.hasExtra(Intent.EXTRA_TEXT)) {
                              val extraText = intent.getStringExtra(Intent.EXTRA_TEXT)

                              extraText?.let {
                                  params[TEXT] = extraText
                              }
                          }

                          eventSink?.success(params)
                      } else if(!ignoring && backlog.contains(intent)) {
                          backlog.add(intent)
                      } else {}
                  }
              }
          }

      } else if(Intent.ACTION_SEND_MULTIPLE == action && type != null) {
          val sharedUri: Uri? = intent.getParcelableExtra(Intent.EXTRA_STREAM);

          sharedUri?.let {
              if (eventSink != null) {
                  val params: HashMap<String, String> = HashMap()

                  params[TYPE] = type
                  params[IS_MULTIPLE] = "true"
                
                    params[0.toString()] = sharedUri.toString()
                  

                  eventSink?.success(params)
              } else if(!ignoring && backlog.contains(intent)) {
                  backlog.add(intent)
              } else {}
          }
      }
  }
}
