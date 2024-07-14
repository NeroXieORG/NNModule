//
//  LoginViewController.swift
//  LoginModule
//
//  Created by NeroXie on 2024/7/13.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Example App"
        view.backgroundColor = .lightGray
        
        let btn = UIButton(frame: .zero)
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        btn.addTarget(self, action: #selector(didButtonPressed), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(30)
        }
    }
    
    @objc private func didButtonPressed() {
        LoginManager.shared.updateLoginStatus(true)
    }
}
