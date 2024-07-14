//
//  ModuleLaunchTaskTest.swift
//  BModule
//
//  Created by NeroXie on 2022/11/17.
//

import Foundation
import NNModule_swift

final class ModuleLaunchTaskTest: NSObject, RegisterLaunchTaskService {
    
    static func keepaliveRegiteredImpl() -> Bool { true }

    func executeTask() {
        let className = NSStringFromClass(type(of: self))
        print("\(className) start task in thread \(Thread.current)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("\(className) finish task")
        }
    }
    
    required override init() { super.init() }
}
