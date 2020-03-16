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
        if indexPath.row == 0 {
            cell?.selectionStyle = .default
            cell?.accessoryType = .disclosureIndicator
        } else {
            cell?.selectionStyle = .none
            cell?.accessoryType = .none
        }
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



final class CTPersonDetailCell: UITableViewCell, CTCellReuseIdentifier, CTCellConstant {
    static var height: CGFloat = 90
    
    private var pre: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
    }
    private var icon: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
    }
    private var detail: UILabel = UILabel().then {
        $0.textColor = .gray
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 17)
    }
    private var _information: (String, String)?
    
    var information: (String, String)? {
        willSet(newValue) {
            guard let info = newValue else {
                return
            }
            _information = info

            self.pre.text = info.0
            if info.1.hasPrefix("https") {
                self.icon.kf.setImage(with: URL(string: info.1))
            } else {
                self.detail.text = info.1
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.pre)
        self.pre.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.cellMargin())
            make.width.equalTo(100)
        })
        
        self.contentView.addSubview(self.icon)
        self.icon.snp.makeConstraints({ (make) in
             make.centerY.equalToSuperview()
             make.right.equalToSuperview().offset(-10)
             make.width.height.equalTo(75)
         })
        
        self.contentView.addSubview(self.detail)
        self.detail.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-1 * self.cellMargin())
            make.left.equalTo(self.pre.snp.right).offset(self.cellMargin())
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
