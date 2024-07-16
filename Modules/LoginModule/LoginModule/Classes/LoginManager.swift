import Foundation
import ModuleServices
import NNModule_swift
import SnapKit

internal final class LoginManager: NSObject, LoginService {

    static let shared = LoginManager()
        
    var isLogin: Bool = false
        
    var loginMain: UIViewController {
        UINavigationController(rootViewController: LoginViewController())
    }
    
    static var implInstance: ModuleBasicService { shared }
    
    func logout() { updateLoginStatus(false) }
    
    func updateLoginStatus(_ loginStatus: Bool) {
        isLogin = loginStatus
        let notification: Notification.Name = loginStatus ? .didLoginSuccess : .didLogoutSuccess
        Module.notificationService.postNotification(for: notification, isSticky: false, object: nil, userInfo: nil)
    }
}




