//
//  HTMLRoutingModule.swift
//  Example_URLRouter
//
//  Created by NeroXie on 2023/11/6.
//

import Foundation
import NNModule_swift
import SafariServices

class HTMLModuleImpl: NSObject, URLRouteModuleType {
    
    var delayedLoadingRoutes: [URLRouteName] { [URLRouter.webLink] }
    
    func configRoutes(with router: URLRouterType) {
        router.registerRoute(URLRouter.webLink) { routeUrl, navigator in
            guard let urlString = routeUrl.parameters["url"] as? String, let url = URL(string: urlString) else {
                return false
            }
            
            navigator.push(SFSafariViewController(url: url))
            return true
        }
        
        router.registerRoute("https://www.baidu.com") { routeUrl, navigator in
            guard let urlString = routeUrl.parameters["url"] as? String, let url = URL(string: urlString) else {
                return false
            }
            
            print("jump to \(url)")
            navigator.push(SFSafariViewController(url: url))
            
            return true
        }
        
        router.registerRoute("https://nero.com") { routeUrl, navigator in
            let url = routeUrl.parameters["url"] ?? ""
            switch routeUrl.path {
            case "/111":
                print("open url: \(url)")
                return true
            default:
                print("\(url) is invalid.")
                return false
            }
        }
    }
}
