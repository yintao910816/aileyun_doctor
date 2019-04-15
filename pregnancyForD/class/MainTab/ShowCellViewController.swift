//
//  ShowCellViewController.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/6/8.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit

class ShowCellViewController: UIViewController {
    
    let fileURLArr = [
        [
            "fileName" : "A01/D2015.10.27_S0078_I697_WELL07",
            "total" : "417"
        ],
        [
            "fileName" : "A02/D2015.11.05_S0107_I698_WELL04",
            "total" : "412"
        ]]
    
    lazy var tableV : UITableView = {
        let t = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        t.tableFooterView = UIView()
        t.dataSource = self
        t.delegate = self
        return t
    }()
    
    let reuseIdentifier = "reuseIdentifier"
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择样本"

        self.view.addSubview(tableV)
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

extension ShowCellViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileURLArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = fileURLArr[indexPath.row]["fileName"] as? String ?? "nothing"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showVC = ShowPicturesViewController()
        showVC.fileURLString = fileURLArr[indexPath.row]["fileName"] as? String ?? ""
        let t = fileURLArr[indexPath.row]["total"] as? String ?? "10"
        HCPrint(message: t)
        if let i = Int(t){
            let j = CGFloat(i)
            HCPrint(message: j)
            showVC.totalIndex = j
            self.navigationController?.pushViewController(showVC, animated: true)
        }
    }
}
