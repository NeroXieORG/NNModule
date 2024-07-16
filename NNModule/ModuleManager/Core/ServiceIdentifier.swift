//
//  ServiceIdentifier.swift
//  NNModule-swift
//
//  Created by NeroXie on 2023/5/29.
//

import Foundation

struct ServiceIdentifier: Hashable {
    
    let value: String
    
    init(_ aProtocol: Protocol) {
        value = NSStringFromProtocol(aProtocol)
    }
    
    init<Generic>(_ aGenericType: Generic.Type) {
        // OC 定义的 service 在 Swift 调用时会带入 __C. 的前缀
        value = String(reflecting: aGenericType).replacingOccurrences(of: "__C.", with: "")
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    static func == (lhs: ServiceIdentifier, rhs: ServiceIdentifier) -> Bool {
        lhs.value == rhs.value
    }
}
