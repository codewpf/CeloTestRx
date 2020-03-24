//
//  CTPersonDetailVC.swift
//  CeloTestRx
//
//  Created by Alex on 16/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Then
import SnapKit

class CTPersonDetailVC: UIViewController {

    let tableView = UITableView().then {
        $0.register(CTPersonDetailCell.self, forCellReuseIdentifier: CTPersonDetailCell.identifier)
    }
    
    let detail: CTDetailModel
    init(detail : CTDetailModel) {
        self.detail = detail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Person Detail"
        self.view.backgroundColor = .white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

extension CTPersonDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CTPersonDetailCell? = tableView.dequeueReusableCell(withIdentifier: CTPersonDetailCell.identifier) as? CTPersonDetailCell
        if cell == nil {
            cell = CTPersonDetailCell(style: .default, reuseIdentifier: CTPersonDetailCell.identifier)
        }
        cell?.selectionStyle = .none
        cell?.accessoryType = .none
        cell?.information = self.detail.details[indexPath.row]
        return cell!
    }
}

extension CTPersonDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CTPersonDetailCell.height
        } else {
            return 40
        }
    }
}



