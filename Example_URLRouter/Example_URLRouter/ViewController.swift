//
//  ViewController.swift
//  Example_URLRouter
//
//  Created by NeroXie on 2021/8/15.
//

import UIKit
import NNModule_swift
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var router: URLRouterType { URLRouter.default }
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var dataList: [[(name: String, handler: () -> Void)]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Example"
        
        dataList = [
            [
                ("case 1：route = module/index?id=123", { self.router.openRoute("module/index?id=123") }),
                ("case 2：route = ://module/index?id=123", { self.router.openRoute("://module/index?id=123") }),
                ("case 3：route = app://module/index?id=123", { self.router.openRoute("app://module/index?id=123") }),
                ("case 4：route = module/index, params = [\"id\":\"123\"]", { self.router.openRoute("module/index", parameters: ["id": "123"]) }),
                ("case 5：route = module/index?<id>, params = [\"id\":\"123\"]", { self.router.openRoute("module/index?<id>", parameters: ["id": "123"]) }),
            ],
            [
                ("HTML default：https://www.neroxie.com", { self.router.openRoute("https://www.neroxie.com") }),
                ("handle specified link：https://www.baidu.com", { self.router.openRoute("https://www.baidu.com") }),
                ("combine test 1：https://nero.com/111?id=123", { self.router.openRoute("https://nero.com/111?id=123") }),
                ("combine test 2：https://nero.com/222?<id>&<num>", { self.router.openRoute("https://nero.com/222?<id>&<num>", parameters: ["id": "123", "num": 10]) }),
            ],
            [
                ("case 1: https://amodule/a?id=123 -> amodule/a", { self.router.openRoute("https://amodule/a?id=123") }),
                ("case 2: amodule/b -> https://amodule/b", { self.router.openRoute("amodule/b", parameters: ["id": "123", "name": "张三"]) })
            ],
            [
                ("case 1：bmodule/main?uid=123", { self.router.openRoute("bmodule/main?uid=123") }),
                ("case 2：bmodule/main", { self.router.openRoute("bmodule/main") }),
            ],
            [
                ("case 1：bmodule/detail?id=123&uid=123", { self.router.openRoute("bmodule/detail?id=123&uid=123") }),
                ("case 2：nero://bmodule/detail?id=123&uid=123", { self.router.openRoute("nero://bmodule/detail?id=123&uid=123") }),
            ]
        ]
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { dataList.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data: [(name: String, handler: () -> Void)] = dataList[section]
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data: [(name: String, handler: () -> Void)] = dataList[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data: [(name: String, handler: () -> Void)] = dataList[indexPath.section]
        let handler = data[indexPath.row].handler
        handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Basic usage"
        case 1: return "HTML test"
        case 2: return "Redirect route test"
        case 3: return "Interceptor test"
        case 4: return "Scheme test"
        default: return nil
        }
    }
}

