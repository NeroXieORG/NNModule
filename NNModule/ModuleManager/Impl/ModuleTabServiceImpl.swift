//
//  ModuleTabManager.swift
//  ModuleManager
//
//  Created by NeroXie on 2019/1/20.
//

import UIKit

class ModuleTabServiceImpl: NSObject, ModuleTabService {
    
    private var registerTypeList: [RegisterTabService.Type] = []
    
    private(set) var tabBarItemMetaList: [TabBarItemMeta] = []
    
    var tabBarController: UITabBarController? = nil
    
    required override init() { super.init() }
    
    func didLoadTabBarController(_ tabBarController: UITabBarController) {
        if let _ = self.tabBarController { return }
        
        self.tabBarController = tabBarController
        
        print(registerTypeList)
        
        for register in registerTypeList {
            let registerImpl = Module.registerImpl(of: register) as! RegisterTabService
            registerImpl.setupTabBarController?(tabBarController)
            let items = registerImpl.registerTabBarItems?() ?? []
            tabBarItemMetaList += items.map { $0.impl = registerImpl; return $0 }
        }
        
        print(tabBarItemMetaList)
    }
    
    func addRegister(_ register: RegisterTabService.Type) {
        if registerTypeList.contains(where: { $0 === register }) { return }
        registerTypeList.append(register)
    }
    
    func needReloadTabBarController() {
        tabBarItemMetaList = []
        tabBarController = nil
    }
    
    func tabItemImpl(in tabBarController: UITabBarController, of viewController: UIViewController) -> RegisterTabService? {
        guard let index = tabBarController.children.firstIndex(of: viewController) else { return nil }
        
        return tabBarItemMetaList[index].impl
    }
}

fileprivate class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        Module.tabService.didLoadTabBarController(self)
        viewControllers = Module.tabService.tabBarItemMetaList.map { $0.viewController }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let impl = Module.tabService.tabItemImpl(in: tabBarController, of: viewController)
        return impl?.tabBarController?(tabBarController, shouldSelect: viewController) ?? true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let impl = Module.tabService.tabItemImpl(in: tabBarController, of: viewController)
        impl?.tabBarController?(tabBarController, didSelect: viewController)
    }
}

