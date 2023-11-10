//
//  RouteParser.swift
//  Router
//
//  Created by NeroXie on 2019/1/8.
//

import Foundation

@objcMembers public class URLRouteParser: NSObject, URLRouteParserType {
    
    public let defaultScheme: String
    
    public required init(defaultScheme: String = "nn") {
        self.defaultScheme = defaultScheme.lowercased()
    }
    
    public func routeUrl(from route: URLRouteName, params: [String : Any]) -> RouteURL? {
        guard let url = url(from: route, params: params) else { return nil }
        
        var scheme = url.scheme?.lowercased().removingPercentEncoding ?? ""
        if scheme == defaultScheme { scheme = "" }
        
        let host = url.host?.lowercased().removingPercentEncoding ?? ""
        
        let path = url.path.removingPercentEncoding ?? ""
        
        let parameters = parameters(with: url.query, params: params)
        
        let routeUrl = RouteURL(scheme: scheme, host: host, path: path, parameters: parameters)
        if (routeUrl.isWebLink) {
            routeUrl.mergingParameters(["url": url.absoluteString])
        }
        
        return routeUrl
    }
    
    private func url(from route: URLRouteName, params: [String : Any]) -> URL? {
        if route.isEmpty { return nil }
        
        var urlString = route
        let schemeRange = (urlString as NSString).range(of: "://")
        if schemeRange.location == NSNotFound {
            urlString = defaultScheme + "://" + urlString
        } else if schemeRange.location == 0 {
            urlString = defaultScheme + urlString
        }
        
        let queryString = queryString(from: urlString, params: params)
        if queryString.isEmpty { return URL(string: urlString) }
        
        var components = URLComponents(string: urlString)
        components?.queryItems? = queryParameters(from: queryString).map { URLQueryItem(name: $0, value: $1) }
        return components?.url
    }
    
    private func queryString(from url: String, params: [String : Any]) -> String {
        let components = url.components(separatedBy: "?")
        if components.count < 2 { return "" }
        
        let queryString = components[1].components(separatedBy: "#")[0]
        var pairs = [String]()
        for string in queryString.components(separatedBy: "&") {
            if string.hasPrefix("<") && string.hasSuffix(">") {
                let start = string.index(string.startIndex, offsetBy: 1)
                let end = string.index(before: string.endIndex)
                let key = String(string[start..<end])
                if let value = params[key] {
                    pairs.append("\(key)=\(value)")
                }
            } else if !string.hasPrefix("<") && !string.hasSuffix(">") {
                pairs.append(string)
            }
        }
        
        return pairs.joined(separator: "&")
    }
    
    private func parameters(with urlQuery: String?, params: [String: Any] = [:]) -> [String: Any] {
        guard let query = urlQuery else { return params }
        
        let parameters: [String: Any] = queryParameters(from: query)
        return parameters.merging(params) { _, second in second }
    }
    
    private func queryParameters(from urlQuery: String?) -> [String: String] {
        var pairs: [String: String] = [:]
        guard let urlQuery = urlQuery, !urlQuery.isEmpty else {
            return pairs
        }
        
        let delimiterSet = CharacterSet(charactersIn: "&;")
        let scanner = Scanner(string: urlQuery)
        while !scanner.isAtEnd {
            var pairString: NSString? = nil
            scanner.scanUpToCharacters(from: delimiterSet, into: &pairString)
            scanner.scanCharacters(from: delimiterSet, into: nil)
            if let kvPair = pairString?.components(separatedBy: "="),
                kvPair.count == 2,
               let key = kvPair[0].removingPercentEncoding,
               let value = kvPair[1].removingPercentEncoding {
                pairs[key] = value
            }
        }
        
        return pairs
    }
}

//fileprivate extension URL {
//
//    func appending(exQueries queries: [String: String]) -> URL {
//        if queries.isEmpty { return self }
//
//        let newQueryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value) }
//        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
//        var oldQueryItems = components?.queryItems ?? []
//        oldQueryItems.removeAll { queryItem in newQueryItems.contains { queryItem.name == $0.name } }
//        components?.queryItems = oldQueryItems + newQueryItems
//
//        return components?.url ?? self
//    }
//}


