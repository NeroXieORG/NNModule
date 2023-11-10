//
//  AModule.swift
//  Example_URLRouter
//
//  Created by NeroXie on 2023/11/6.
//

import Foundation
import NNModule_swift

class AModuleImpl: NSObject, URLRouteModuleType {
    
    var delayedLoadingRoutes: [URLRouteName] { ["amodule"] }
    
    func configRoutes(with router: URLRouterType) {
        router.registerRoute("amodule/a") { routeUrl, navigator in
            navigator.push(APageViewController(), animated: true)
            return true
        }
        
        router.registerRoute("amodule/b") { routeUrl, navigator in
            navigator.present(BPageViewController(), animated: true)
            return true
        }
    }
}

class APageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
}

class BPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
    }
}
