////
////  ARouteModule.swift
////  AModule
////
////  Created by NeroXie on 2023/11/11.
////
//
//import Foundation
//import NNModule_swift
//import SafariServices
//
//class ARouteModule: NSObject, URLRouteModuleType {
//    
//    
//    var delayedLoadingRoutes: [URLRouteName] { ["house", URLRouter.webLink] }
//    
//    func configRoutes(with router: URLRouterType) {
//        router.registerRoute(URLRouter.webLink) { url, navigator in
//            guard let string = url.parameters["url"] as? String, let url = URL(string: string) else { return false }
//            
//            navigator.push(SFSafariViewController(url: url))
//            return true
//        }
//        
//        router.registerRoute("house") { routeUrl, navigator in
//            switch routeUrl.path {
//            case "/main":
//                let vc = HouseListViewController()
//                vc.modalPresentationStyle = .fullScreen
//                navigator.present(vc, wrap: UINavigationController.self, animated: true)
//                return true
//            case "/add":
//                navigator.push(AddHouseViewController())
//                return true
//            default: return false
//            }
//        }
//    }
//}
