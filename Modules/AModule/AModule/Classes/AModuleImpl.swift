import NNModule_swift
import ModuleServices
import TabBarController
import ESTabBarController_swift
import BaseModule

extension Module.RegisterService {
    
    @objc static func aModuleRegisterService() {
        Module.register(service: HouseService.self, used: HouseManager.self)
    }
}

extension Module.Awake {
    
    @objc static func aModuleAwake() {
        Module.tabService.addRegister(AModuleImpl.self)
        Module.launchTaskService.addRegister(ModuleLaunchTaskTest.self)
        Module.routeService.addRouteModule(ARouteModule())
    }
}

class AModuleImpl: NSObject, RegisterTabService, NibLoadable {
    
    required override init() {
        super.init()
        
        print("============\(type(of: self))===============")
        let bundle1 = Bundle.init(for: type(of: self))
        print(bundle1)
        bundle1.paths(forResourcesOfType: "bundle", inDirectory: nil).forEach {
            print($0)
        }
        
        if let bundleURL = bundle1.url(forResource: nil, withExtension: "bundle") {
            print("获取bundle url = \(bundleURL)")
        }
    }
    
    // MARK: - RegisterTabItemService
    
    func setupTabBarController(_ tabBarController: UITabBarController) {
        if let tabBarController = tabBarController as? TabBarController {
            tabBarController.shouldHijackHandler = { _ ,_ , index in index == 1 }
            tabBarController.didHijackHandler = { _, _, _ in Module.routeService.openRoute("house/main") }
        }
    }
    
    func registerTabBarItems() -> [TabBarItemMeta] {
//        let bundle = resourceBundle(of: "AModule")
        let bundle = self.resourceBundle()
        var metaList = [TabBarItemMeta]()
        let configImpl = Module.serviceImpl(of: ModuleConfigService.self)
        
        if let index = configImpl.tabBarItemIndex(for: "example") {
            let nav = UINavigationController(rootViewController: ExampleViewController())
            let image = UIImage(named: "tabbar_houses_normal", in: bundle, compatibleWith: nil)
            let selectedImage = UIImage(named: "tabbar_houses_normal", in: bundle, compatibleWith: nil)
            nav.tabBarItem = ESTabBarItem(NormalTabBarItemContentView(), title: "example", image: image, selectedImage: selectedImage)
            let meta = TabBarItemMeta()
            meta.viewController = nav
            meta.tabIndex = UInt(index)
            metaList.append(meta)
        }
        
        if let index = configImpl.tabBarItemIndex(for: "house") {
            let vc = UIViewController()
            let image = UIImage(named: "tabbar_add", in: bundle, compatibleWith: nil)
            vc.tabBarItem = ESTabBarItem(LargeTabBarItemContentView(), title: "house", image: image)
            let meta = TabBarItemMeta()
            meta.viewController = vc
            meta.tabIndex = UInt(index)
            metaList.append(meta)
        }
        
        return metaList
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("\(type(of: self))：\(#function)")
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("\(type(of: self))：\(#function)")
    }
}



