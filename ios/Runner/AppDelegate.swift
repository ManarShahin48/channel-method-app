import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery", binaryMessenger: controller.binaryMessenger)
    let sumChannel = FlutterMethodChannel(name: "samples.flutter.dev/sum", binaryMessenger: controller.binaryMessenger)
    let imgChannel = FlutterMethodChannel(name: "samples.flutter.dev/img", binaryMessenger: controller.binaryMessenger)

    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
           guard call.method == "getBatteryLevel" else {
             result(FlutterMethodNotImplemented)
             return
           }
          self.receiveBatteryLevel(result: result)
    })


    sumChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: FlutterResult) in
        if call.method == "calculateSum" {
            if let arguments = call.arguments as? [String: Any],
               let a = arguments["a"] as? Int,
               let b = arguments["b"] as? Int {
                let sum = self?.sum(a: a, b: b) ?? 0
                result(sum)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
        
    imgChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
           guard call.method == "img" else {
             result(FlutterMethodNotImplemented)
             return
           }
          self.getImg(result: result)
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func receiveBatteryLevel(result: FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    if device.batteryState == UIDevice.BatteryState.unknown {
      result(FlutterError(code: "UNAVAILABLE", message: "Battery level not available.", details: nil))
    } else {
      result(Int(device.batteryLevel * 100))
    }
  }

  private func sum(a: Int, b: Int) -> Int {
          return a + b
  }

  private func getImg(result: FlutterResult){
      let v = "https://files.ekmcdn.com/0ec9a8/images/palestine-5ft-x-3ft-flag-1-842-p.jpg?w=1000&h=1000&v=6122022-153920"
      result(v)
  }

}
