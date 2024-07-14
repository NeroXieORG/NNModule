//
//  ModuleTabManager.swift
//  ModuleManager
//
//  Created by NeroXie on 2019/1/20.
//

import UIKit

class ModuleTabServiceImpl: NSObject, ModuleTabService {
    
    static var implInstance: ModuleBasicService { ModuleTabServiceImpl() }
    
//    private var _tabBarController: UITabBarController?
    
    private var registerTypeList: [RegisterTabItemService.Type] = []
    
//    private var tabItemImpls: [RegisterTabItemService] = []
    
    private(set) var tabBarItemMeta: [TabBarItemMeta] = []
    
    public var tabBarController: UITabBarController? = nil
    
//    var tabBarControllerType: UITabBarController.Type = TabBarController.self
//    
//    var tabBarController: UITabBarController { _tabBarController ?? tabBarControllerType.init() }
//    public var tabBarController: UITabBarController { _tabBarController ?? tabBarControllerType.init() }
    
    required override init() { super.init() }
    
    func tabBarControllerDidLoad() {
        guard let tabBarController = self.tabBarController else {
            return
        }

        for register in registerTypeList {
            let registerImpl = Module.registerImpl(of: register) as! RegisterTabItemService
            registerImpl.setupTabBarController?(tabBarController)
            let tabBarItems = registerImpl.registerTabBarItems?() ?? []
            tabBarItemMeta += tabBarItems.map { $0.impl = registerImpl; return $0 }
        }
        
        tabBarItemMeta = tabBarItemMeta.sorted(by: { $0.tabIndex < $1.tabIndex })
    }
    
//    func setupTabBarController(with tabBarController: UITabBarController) {
//        _tabBarController = tabBarController
//        
//        tabItemImpls.forEach { impl in
//            impl.setupTabBarController?(tabBarController)
//            tabBarItemMeta += (impl.registerTabBarItems?() ?? []).map { $0.impl = impl; return $0 }
//        }
//        
//        tabBarItemMeta = tabBarItemMeta.sorted(by: { $0.tabIndex < $1.tabIndex })
//    }
    
    func addRegister(_ register: RegisterTabItemService.Type) {
//        tabItemImpls.append(Module.registerImpl(of: register) as! RegisterTabItemService)
        if registerTypeList.contains(where: { $0 === register }) { return }
        registerTypeList.append(register)
    }
    
    func needReloadTabBarController() {
        tabBarItemMeta = []
        tabBarController = nil
//        _tabBarController = nil
    }
    
    func impl(in tabBarController: UITabBarController, of viewController: UIViewController) -> RegisterTabItemService? {
        guard let index = tabBarController.children.firstIndex(of: viewController) else { return nil }
        
        return tabBarItemMeta[index].impl
    }
}

fileprivate class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        Module.tabService.tabBarControllerDidLoad()
//        Module.tabService.setupTabBarController(with: self)
        viewControllers = Module.tabService.tabBarItemMeta.map {  $0.viewController }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let impl = Module.tabService.impl(in: tabBarController, of: viewController)
        return impl?.tabBarController?(tabBarController, shouldSelect: viewController) ?? true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let impl = Module.tabService.impl(in: tabBarController, of: viewController)
        impl?.tabBarController?(tabBarController, didSelect: viewController)
    }
}

