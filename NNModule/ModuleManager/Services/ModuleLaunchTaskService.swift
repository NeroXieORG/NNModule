//
//  ModuleLaunchTaskService.swift
//  ModuleManager
//
//  Created by NeroXie on 2020/11/19.
//

import Foundation

@objc public enum ModuleLaunchTaskRunMode : Int {
    
    case asyncOnMain
    
    case asynOnGlobal
    
    case syncOnMain
}

@objc public enum ModuleLaunchTaskPriority: Int {
    
    case low = 100
    
    case `default` = 200
    
    case high = 300
}

/// The service of register launch tasks
@objc public protocol RegisterLaunchTaskService: ModuleRegisteredService {
    
    /// Run mode of launch task, default is `ModuleLaunchTaskRunModeasynOnGlobal`
    @objc optional var runMode: ModuleLaunchTaskRunMode { get }
    
    /// Priority of launch task, defualt is `ModuleLaunchTaskPriority.default`
    @objc optional var priority: ModuleLaunchTaskPriority { get }
    
    /// execute task
    func executeTask()
}

/// Launch Task Service
@objc public protocol ModuleLaunchTaskService: ModuleFunctionalService {
    
    /// Add register of launch tasks
    func addRegister(_ register: RegisterLaunchTaskService.Type)
    
    /// execute all launch tasks
    func executeTasks()
}



