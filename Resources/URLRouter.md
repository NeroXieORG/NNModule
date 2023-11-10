# URLRouter

更新于2020-12-13【v1.0.7 简化 URLRouter 结构，使用路由模块化的方式实现按需注册路由，替换原有的路由延时注册、router 嵌套】

## 简介

URLRouter 是一个基于对 URL 的解析，简单、方便、轻量的路由跳转方式。提供的功能如下：
+ 路由注册与跳转
+ 路由拦截
+ 路由重定向
+ 路由模块化（实现按需注册路由）
+ 兼容 OC
+ ~~路由延时注册~~
+ ~~router 嵌套~~ 

## 使用

### 使用前

在使用前先介绍下 URLRouter 中的相关概念：

+ `URLRouterType`: 定义 router 的接口，`URLRouter` 为默认实现
+ `URLRouteModuleType`: 定义路由模块化的接口
+ ~~`URLNestingRouterType`: 定义 router 嵌套的接口，`URLRouter` 为默认实现~~
+ `URLRouterTypeAttach`: 定义了 router 的其他拓展功能的接口， `URLRouter` 为默认实现
+ `URLRouteParserType`: 定义 URL 解析的接口，`URLRouteParser` 为默认实现
+ `NavigatorType`: 定义导航的接口，`Navigator` 为默认实现
+ `URLRouteRedirector`: 路由重定向器
+ `URLRouteInterceptor`: 路由拦截器
+ `URLRouteInterceptionAction`: 路由拦截行为，一个路由拦截器会有多个 action，`URLRouteInterceptor.Action` 为默认实现
+ `RouteURL`: 描述路由的数据对象

### 创建 router

```swift
let routeParser = URLRouteParser(defaultScheme: "your app scheme")
URLRouter.default = URLRouter(routeParser: routeParser, navigator: Navigator())
// or
let router = URLRouter(routeParser: routeParser, navigator: Navigator())
```

URLRouter 提供了一个默认的 router `URLRouter.default`，但只是方便作为根 router 而存在，可以在项目初始化时重新定义，也可以根据 `URLRouterType` 自定义一个 router 类。

### 路由注册与跳转

URLRouter 支持单条路由、聚合路由的注册。

路由注册：

```swift
let router = URLRouter.default

// 注册单条路由
router.registerRoute("module/apage") { routeUrl, navigator in
    navigator.push(AViewController(), animated: true)
    
    return true
}

router.registerRoute("module/bpage") { routeUrl, navigator in
    navigator.push(BViewController(), animated: true)
    
    return true
}

// 使用聚合路由注册替换上面的单条路由注册
router.registerRoute("module") { routeUrl, navigator in
    switch routeUrl.path {
    case "/apage":
        navigator.push(AViewController(), animated: true)
        return true
    case "/bpage":
        navigator.push(BViewController(), animated: true)
        return true
    default:
        return false
    }
}
```

路由跳转支持多种写法：

```swift
router.openRoute("module/apage", parameters: ["id": 111, "name": "nero"])
// or
router.openRoute("://module/apage", parameters: ["id": 111, "name": "nero"])
// or
router.openRoute("nn://module/apage", parameters: ["id": 111, "name": "nero"])
// or
router.openRoute("://module/apage?id=111&name=nero")
// or
router.openRoute("nn://module/apage?id=111&name=nero")
// or
router.openRoute("module/apage?<id>&<name>", parameters: ["id": 111, "name": "nero"])
```

上述写法均等同于 `router.openRoute("nn://module/apage?id=111&name=nero")`

注意事项：

+ 传入的路由需要符合 URL 的规范
+ 可以省略对默认的 scheme 声明，scheme 和 host 不区分大小写，path 区分大小写
+ 若有单条路由的 handler 则会优先匹配，否则就会尝试匹配聚合路由的 handler，URLRouter 使用 `scheme://host` 做为聚合路由
+ 定义路由时处于同一业务模块的路由建议使用同一个 host，根据 path 的不同来区分 handler ，使用聚合路由注册可以减少整体路由表的大小
+ 注册路由时无需考虑 parameters，跳转路由时需要考虑 parameters
+ 跳转路由时支持 parameters 传递对象类型的数据
+ 跳转路由时，parameters 和 URL 的 query 存在相同键时，使用 parameters 中的值
+ 1.0.7 新增路由 parameters `<key>` 适配符写法。当跳转路由为非原生链接（如 http 链接，第三方链接等），且 parameters 是混合参数的情况下，可以使用 `<key>` 适配符写法从混合参数中提取所需的键值对来组装出一条正确的 URL 

### 路由重定向

URLRouter 支持对将要跳转的路由进行重定向操作，重定向可以结合远程接口对路由进行升/降级。

```swift
// 重定向表
let routeMap = ["https://redirect.com/main" : "redirect/main"]
URLRouter.default.routeRedirector.updateRedirectRoutes(routeMap)

// 跳转 https://redirect.com/main 会重定向到 redirect/main
URLRouter.default.openRoute("https://redirect.com/main")
```

### 路由拦截

拦截器的作用主要是对匹配到的路由进行拦截，之后根据开发者的规则来判定拦截与否，若拦截成功，那么路由对应的 handler 则不会执行。URLRouter 中使用 `URLRouteInterceptor` 类拦截路由，`URLRouteInterceptor`包含多个拦截 Action `URLRouteInterceptionAction`，每个拦截 Action 中开发者可以自定义拦截规则。

一个路由可以匹配多个拦截 Action，只要有一个拦截 Action 拦截成功，则视为拦截成功。拦截 Action 是有顺序的，通常先添加的 Action 会先调用，也可以使用 `URLRouteInterceptor` 的 `func insert(_ action: URLRouteInterceptionAction, at i: Int)` 函数修改顺序。

`URLRouteInterceptor` 定义：

```swift
public class URLRouteInterceptor {
    // 插入 Action
    public func insert(_ action: URLRouteInterceptionAction, at i: Int) 
    // 添加 Action
    public func append(_ action: URLRouteInterceptionAction) 
    // 删除 Action
    public func remove(_ action: URLRouteInterceptionAction)
}
```

`URLRouteInterceptionAction` 定义：

```swift
public protocol URLRouteInterceptionAction: AnyObject {
    // 指定的路由，返回空数组或 nil 时，该 action 匹配所有路由
    var specifiedRoutes: [URLRouteConvertible]? { get }
    // 定义拦截规则
    func interceptRoute(for routeUrl: RouteURL) -> URLRouteInterceptionResult
}
```

使用默认拦截 Action：

```swift
let action = URLRouteInterceptor.Action(specifiedRoutes: ["module"]) {
    // 定义拦截规则
}
// 添加拦截 action
// 该 action 会匹配 scheme 为 default scheme 且 host 为 `module` 的所有路由。
URLRouter.default.routeInterceptor.append(action)
```

使用自定义拦截 Action：

```swift
// 定义拦截 Action
class PermissionAction: URLRouteInterceptionAction {
    
    var specifiedRoutes: [URLRouteConvertible]? { ["module"] }
    
    func interceptRoute(for routeUrl: RouteURL) -> URLRouteInterceptionResult {
        guard LoginManager.shared.isLogin else {
            // 跳转登录
            URLRouter.default.openRoute("login/main")
            return .reject
        }
        
        var params = routeUrl.parameters
        if params["permission"] == nil {
            params["permission"] = 1
            // 更新路由参数
            routeUrl.resetParameters(params)
        }
        
        return .next
    }
}

// 插入拦截 Action
// 该 action 会匹配 scheme 为 default scheme 且 host 为 `module` 的所有路由。
URLRouter.default.routeInterceptor.insert(PermissionAction(), at: 0)
```

### 路由模块化

URLRouter 在设计结构的时候一直都把优化路由表大小当做一个特点，使用了聚合路由、路由懒加载、路由嵌套来优化，但是这一设计过于繁琐，因此在 1.0.7 版本中使用路由模块化实现按需注册路由的方式来替换路由懒加载、路由嵌套并简化 API 的调用。

`URLRouteModuleType` 的相关定义：

```swift
// 1.0.7 新增
@objc public protocol URLRouteModuleType: NSObjectProtocol {
    
    @objc optional var delayedLoadingRoutes: [URLRouteName] { get }
    
    func configRoutes(with router: URLRouterType)
}

@objc public protocol URLRouterType: NSObjectProtocol {
    // 1.0.7 新增
    func addRouteModule(_ routeModule: URLRouteModuleType)
}
```

每一个 route module 代表一个业务模块，使用 `addRouteModule(_ routeModule:)` 函数添加 route module。当 router 添加 route module 时，如果当前 route module 的 `delayedLoadingRoutes` 未实现或者返回一个空数组，意味着该模块的路由不需要按需注册，会立即调用 `configRoutes(with router:)` 函数，否则，`configRoutes(with router:)` 函数会等到使用 `openRoute(_ route:, parameters:)` 跳转 `delayedLoadingRoutes` 中包含的路由时才被调用。这种按需加载路由的方式可以从根本解决 router 内部路由表大小的问题。

假设项目中有 A 和 B 两个业务模块，当某次使用 App 时，仅需要调用 A 模块的路由，那么此时在路由表中仅需要存在 A 模块的路由即可，而 B 模块的路由应该等到使用 B 模块相关的路由时才注册。

A 模块示例代码：

```swift
class AModuleImpl: NSObject, URLRouteModuleType {
    
    var delayedLoadingRoutes: [URLRouteName] { ["amodule"] }
    
    func configRoutes(with router: URLRouterType) {
        router.registerRoute("amodule/a") { routeUrl, navigator in
            navigator.push(APageViewController(), animated: true)
            return true
        }
        
        router.registerRoute("amodule/b") { routeUrl, navigator in
            navigator.present(BPageViewController(), animated: true)
            return true
        }
    }
}
```

`AModuleImpl` 中的 `delayedLoadingRoutes` 返回了 `amodule`，这代表当 router 准备跳转某条路由时，如果该路由满足 scheme 为 default scheme，host 为 `amodule` 的话，会优先调用 `AModuleImpl` 的 `configRoutes(with router:)` 先注册路由（已经调用过的不会重复调用），再跳转。

注意事项：

+ `delayedLoadingRoutes` 中的路由需要与真正注册路由一致或为其聚合路由，建议使用聚合路由作为 `delayedLoadingRoutes` 数组中的元素。

### 兼容 OC

URLRouter 已支持对 OC 的兼容，可以在混编项目或纯 OC 项目中使用。OC 项目中使用 URLRouter 需引入 `#import <NNModule_swift/NNModule_swift-Swift.h>`。 

在 OC 项目中自定义 Router 可参考 [OC 自定义 Router](https://github.com/YiHuaXie/NNModule/blob/supportOC/Modules/ConfigModule/ConfigModule/Classes/Router.m) 。

### 其他

#### 对Http/Https的支持

URLRouter 提供了一个 webLink 的路由名支持对 Http/Https 链接的统一处理，也可以通过注册指定链接优先处理该指定链接。

```swift
let router =  URLRouter.default
router.registerRoute(router.webLink) { routeUrl, navigator in
    // 统一处理
}

router.registerRoute("https://www.baidu.com") { url, navigator in
    // 单独处理某个链接
}
```

#### 获取最顶层的ViewController

```swift
let viewController: UIViewController? = UIApplication.topViewController
```

#### 关于定制

URLRouter 是面向协议进行开发的，开发者可以根据`URLRouteType`、`URLRouteParserType`以及`NavigatorType`提供的接口自定义规则进行实现。

~~在基于 `URLRouteType` 自定义 router 尤其是根 router 时，除了路由注册与跳转的功能以外其他功能都是非必须功能可不实现，`URLRouteType` 的 extension 默认实现中会通过断言抛出异常来提示开发者使用了未实现的功能。~~

## 要求

`iOS 10+`

## 安装

```ruby
pod 'NNModule-swift/URLRouter'
```

## Example

这里提供了一个[Example App](../Example_URLRouter/)，支持DeepLink。

1. 下载 Example App
2. 运行 `pod install` 或者 `pod update`
3. 编译并运行 App
4. 打开 Safari
5. 输入`nn://`即可打开 Example App

## 其他功能

点击[这里](../README.md)可查看 NNModule-swift 的其他功能。