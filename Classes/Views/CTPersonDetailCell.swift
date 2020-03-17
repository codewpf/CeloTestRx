//
//  CTPersonDetailCell.swift
//  CeloTestRx
//
//  Created by Alex on 17/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

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
