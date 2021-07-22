import UIKit
import Flutter
//import Firebase
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//       return true
//    FirebaseApp.configure()
    var flutter_native_splash = 1
    UIApplication.shared.isStatusBarHidden = false

    GeneratedPluginRegistrant.register(with: self)
    
    //weak var registrar = self.registrar(forPlugin: "plugin-name")

    //        let factory = FLNativeViewFactory(messenger: registrar!.messenger())
    //        self.registrar(forPlugin: "<plugin-name>")!.register(
    //            factory,
    //            withId: "<platform-view-type>")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
