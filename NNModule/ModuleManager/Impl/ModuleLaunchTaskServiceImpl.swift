//
//  ModuleLaunchTaskServiceImpl.swift
//  ModuleManager
//
//  Created by NeroXie on 2020/11/19.
//

import Foundation

class ModuleLaunchTaskServiceImpl: NSObject, ModuleLaunchTaskService {
    
    private var registerTypeList: [RegisterLaunchTaskService.Type] = []
    
    required override init() { super.init() }
    
    func addRegister(_ register: RegisterLaunchTaskService.Type) {
        if (registerTypeList.contains(where: { $0 == register })) {
            print("有重复 过滤")
            return
        }
        
        registerTypeList.append(register)
    }
    
    func executeTasks() {
        let taskImpls = registerTypeList.map { Module.registerImpl(of: $0) as! RegisterLaunchTaskService }
            .sorted { ($0.priority ?? .default).rawValue > ($1.priority ?? .default).rawValue }
        
        for taskImpl in taskImpls {
            let runMode = taskImpl.runMode ?? .asynOnGlobal
            switch runMode {
            case .syncOnMain:
                taskImpl.executeTask()
            case .asyncOnMain:
                DispatchQueue.main.async { taskImpl.executeTask() }
            case .asynOnGlobal:
                DispatchQueue.global(qos: .default).async { taskImpl.executeTask() }
            }
        }
    }
}
