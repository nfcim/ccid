package im.nfc.ccid

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.*
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterCcidPlugin */
class FlutterCcidPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var usbManager: UsbManager
    private val readers = mutableMapOf<String, Reader>()

    private val usbReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action == ACTION_USB_PERMISSION) {
                val device: UsbDevice? = intent.getParcelableExtra(UsbManager.EXTRA_DEVICE)
                if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                    device?.apply {
                        val reader = readers[intent.identifier]
                        if (reader == null) {
                            Log.e(TAG, "Reader not found")
                            return
                        }
                        val ccid = connectToInterface(device, reader.interfaceIdx)
                        if (ccid != null) {
                            readers[reader.name] =
                                Reader(reader.name, reader.interfaceIdx, ccid, null)
                            reader.result!!.success(null)
                        } else {
                            reader.result!!.error(
                                "CCID_READER_CONNECT_ERROR",
                                "Failed to connect",
                                null
                            )
                        }
                    }
                } else {
                    Log.d(TAG, "permission denied for device $device")
                }
            }
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_ccid")
        channel.setMethodCallHandler(this)
    }

    @OptIn(ExperimentalStdlibApi::class)
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "listReaders" -> {
                result.success(listReaders())
            }

            "connect" -> {
                val reader = call.arguments as String
                connect(reader, result)
            }

            "transceive" -> {
                val readerName = call.argument<String>("reader")!!
                val capdu = call.argument<String>("capdu")!!
                val reader = readers[readerName]
                if (reader == null) {
                    result.error("CCID_READER_NOT_FOUND", "Reader not found", null)
                    return
                }
                val ccid = reader.ccid
                if (ccid == null) {
                    result.error("CCID_READER_NOT_CONNECTED", "Reader not connected", null)
                    return
                }
                val resp = ccid.xfrBlock(capdu.hexToByteArray())
                result.success(resp.toHexString())
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        context = binding.activity.applicationContext
        usbManager = context.getSystemService(Context.USB_SERVICE) as UsbManager
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}

    private fun listReaders(): List<String> {
        // TODO: readers with the same name
        val readers = mutableListOf<String>()

        usbManager.deviceList.values.forEach { device ->
            (0 until device.interfaceCount).forEach { i ->
                val usbInterface = device.getInterface(i)
                if (usbInterface.interfaceClass == UsbConstants.USB_CLASS_CSCID) {
                    readers.add(getDisplayName(device, usbInterface))
                }
            }
        }

        return readers
    }

    private fun connect(reader: String, result: Result) {
        usbManager.deviceList.values.forEach { device ->
            (0 until device.interfaceCount).forEach { i ->
                val usbInterface = device.getInterface(i)
                if (getDisplayName(device, usbInterface) == reader) {
                    if (!usbManager.hasPermission(device)) {
                        context.registerReceiver(usbReceiver, IntentFilter(ACTION_USB_PERMISSION))

                        // Request permission
                        readers[reader] = Reader(reader, i, null, result)
                        val intent = Intent(ACTION_USB_PERMISSION)
                        intent.identifier = reader
                        val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, 0)
                        usbManager.requestPermission(device, pendingIntent)

                        return
                    } else {
                        val ccid = connectToInterface(device, i)
                        if (ccid != null) {
                            readers[reader] = Reader(reader, i, ccid, null)
                            result.success(null)
                        } else {
                            result.error("CCID_READER_CONNECT_ERROR", "Failed to connect", null)
                        }
                    }
                }
            }
        }
        result.error("CCID_READER_NOT_FOUND", "Reader not found", null)
    }

    @OptIn(ExperimentalStdlibApi::class)
    private fun connectToInterface(device: UsbDevice, interfaceIdx: Int): Ccid? {
        val usbInterface = device.getInterface(interfaceIdx)
        val usbConnection = usbManager.openDevice(device)
        if (usbConnection == null) {
            Log.e(TAG, "Failed to open device")
            return null
        }
        val endpoints = getEndpoints(usbInterface)
        val ccid = Ccid(usbConnection, endpoints.first, endpoints.second)
        val descriptor = ccid.getDescriptor(interfaceIdx)
        if (descriptor?.supportsProtocol(Protocol.T1) != true) {
            Log.d(TAG, "Unsupported protocol")
            return null
        }
        if (!usbConnection.claimInterface(usbInterface, true)) {
            Log.e(TAG, "Failed to claim interface")
            return null
        }
        val atr = ccid.iccPowerOn()
        Log.d(TAG, "ATR: ${atr.toHexString()}")
        return ccid
    }

    private fun getEndpoints(usbInterface: UsbInterface): Pair<UsbEndpoint, UsbEndpoint> {
        var bulkIn: UsbEndpoint? = null
        var bulkOut: UsbEndpoint? = null
        for (i in 0 until usbInterface.endpointCount) {
            val endpoint = usbInterface.getEndpoint(i)
            if (endpoint.type == UsbConstants.USB_ENDPOINT_XFER_BULK) {
                if (endpoint.direction == UsbConstants.USB_DIR_IN) {
                    bulkIn = endpoint
                } else {
                    bulkOut = endpoint
                }
            }
        }
        if (bulkIn == null || bulkOut == null) {
            throw Exception("Bulk endpoints not found")
        }
        return Pair(bulkIn, bulkOut)
    }

    private fun getDisplayName(device: UsbDevice, usbInterface: UsbInterface): String {
        val nameParts = mutableListOf<String>()
        if (device.productName != null) {
            nameParts.add(device.productName!!)
        } else {
            nameParts.add("Unknown")
        }

        if (usbInterface.name != null) {
            nameParts.add(usbInterface.name!!)
        } else {
            nameParts.add("CCID")
        }

        return nameParts.joinToString(" ")
    }

    companion object {
        private val TAG = FlutterPlugin::class.java.name
        private const val ACTION_USB_PERMISSION = "im.nfc.ccid.USB_PERMISSION"
        private const val TIMEOUT = 1000
    }

    private data class Reader(
        val name: String,
        val interfaceIdx: Int,
        val ccid: Ccid?,
        val result: Result?
    )
}
