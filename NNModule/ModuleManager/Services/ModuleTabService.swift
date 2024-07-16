//
//  ModuleTabService.swift
//  ModuleManager
//
//  Created by NeroXie on 2019/1/20.
//

import UIKit

/// TabBar service.
@objc public protocol ModuleTabService: ModuleFunctionalService {
    
    /// The instance of tabBar controller
    var tabBarController: UITabBarController? { set get }
    
    /// The meta of tabBar item
    var tabBarItemMetaList: [TabBarItemMeta] { get }
    
    /// Add register of tabBar item
    func addRegister(_ register: RegisterTabService.Type)
    
    /// TabBar controller did load
    func didLoadTabBarController(_ tabBarController: UITabBarController)
    
    /// Need to reload the tabBar.
    func needReloadTabBarController()
    
    /// Get the instance of RegisterTabItemService corresponding to the viewController.
    /// - Parameters:
    ///   - tabBarController: The instance of current tabBar controller
    ///   - viewController: The specified ViewController
    /// - Returns: RegisterTabItemService
    func tabItemImpl(in tabBarController: UITabBarController, of viewController: UIViewController) -> RegisterTabService?
}

/// Register tabBar item
@objc public protocol RegisterTabService: ModuleRegisteredService, UITabBarControllerDelegate {
    
    /// Setup the tabBar controller when created
    @objc optional func setupTabBarController(_ tabBarController: UITabBarController)
    
    /// Register tabBar items
    @objc optional func registerTabBarItems() -> [TabBarItemMeta]
}

/// The meta that describe tabBar item.
@objcMembers public class TabBarItemMeta: NSObject {
    
    internal var impl: RegisterTabService?
    
    public var viewController: UIViewController
    
    public var tabIndex: Int
    
    public init(viewController: UIViewController, tabIndex: Int) {
        self.viewController = viewController
        self.tabIndex = tabIndex
        
        super.init()
    }
}
