import UIKit
import SwiftMonkeyPaws

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    var paws: MonkeyPaws?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if nil == window {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
        }
        coordinator = Coordinator(window: window!)
        coordinator?.appStart()

        print(CommandLine.arguments)
        if CommandLine.arguments.contains("--MonkeyPaws") {
            paws = MonkeyPaws(view: window!)
            coordinator?.uiTesting = true
            print("UITesting")
        }

        return true
    }
}
