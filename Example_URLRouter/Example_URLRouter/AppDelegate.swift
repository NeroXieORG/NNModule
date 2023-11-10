//
//  AppDelegate.swift
//  Example_URLRouter
//
//  Created by NeroXie on 2021/8/15.
//

import UIKit
import NNModule_swift
import SafariServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupRouter()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.backgroundColor = .white
        window.rootViewController = UINavigationController(rootViewController: ViewController())
        window.makeKeyAndVisible()
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        // Support Deeplink
        if URLRouter.default.openRoute(url.absoluteString) { return true }
        
        return false
    }
    
    private func setupRouter() {
        let routeParser = URLRouteParser(defaultScheme: "nn")
        let router = URLRouter(routeParser: routeParser)
        router.addRouteModule(HTMLModuleImpl())
        router.addRouteModule(AModuleImpl())
        router.addRouteModule(BModuleImpl())
        router.registerRoute("module/index") { routeUrl, navigator in
            navigator.push(UIViewController(), animated: true)
            return true
        }
        
        router.routeInterceptor.append(LoginAction())
        router.routeInterceptor.insert(URLRouteInterceptor.Action.init { routeUrl in
            print("\n================ Test case ================")
            print(routeUrl)
            print("===========================================\n")
            return .next
        }, at: 0)
        
        router.routeInterceptor.insert(LoginAction(), at: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            router.routeRedirector.updateRedirectRoutes([
                "amodule/b": "https://amodule/b?<id>&<name>",
                "https://amodule/a": "amodule/a"
            ])
        }
        
        URLRouter.default = router
    }
}

class LoginAction: NSObject, URLRouteInterceptionAction {
    
    var specifiedRoutes: [URLRouteName]? { ["bmodule"] }
    
    func interceptRoute(for routeUrl: RouteURL) -> URLRouteInterceptionResult {
        if routeUrl.parameters["uid"] == nil {
            let alert = UIAlertController(title: "Login error", message: "no uid", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            UIApplication.topViewController?.present(alert, animated: true)
            
            return .reject
        }
        
        return .next
    }
}


