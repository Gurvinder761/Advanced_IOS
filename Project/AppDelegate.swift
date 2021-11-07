
import  UIKit
import  CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  lazy var  coreDataStack = CoreDataStack(modelName: "Model")

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

      guard let navController = window?.rootViewController as? UINavigationController,
      let viewController = navController.topViewController as? ViewController else  {
         return true
       }

    viewController.coreDataStack =  coreDataStack
    
    return true
  }

  func applicationWillTerminate(_ application: UIApplication)
  {
    coreDataStack.saveContext()
  }
}


