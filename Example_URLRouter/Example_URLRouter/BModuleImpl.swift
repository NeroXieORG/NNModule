//
//  BModuleImpl.swift
//  Example_URLRouter
//
//  Created by NeroXie on 2023/11/6.
//

import Foundation
import NNModule_swift

class BModuleImpl: NSObject, URLRouteModuleType {
    
    var delayedLoadingRoutes: [URLRouteName] { ["bmodule"] }
    
    func configRoutes(with router: URLRouterType) {
        router.registerRoute("bmodule/main") { routeUrl, navigator in
            navigator.push(BModuleMainViewController())
            return true
        }
        
        router.registerRoute("bmodule/detail") { routeUrl, navigator in
            navigator.push(BModuleDetailViewController())
            return true
        }
    }
}

fileprivate class BModuleMainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "BModuleMain"
        self.view.backgroundColor = .yellow
    }
}

fileprivate class BModuleDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "BModuleDetail"
        self.view.backgroundColor = .green
    }
}

