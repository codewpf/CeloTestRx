//
//  CTPersonListCell.swift
//  CeloTestRx
//
//  Created by Alex on 17/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

final class CTPersonListCell: UITableViewCell, CTCellReuseIdentifier, CTCellConstant {
    static var height: CGFloat = 90
    
    private let icon: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
    }
    private let name: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20)
    }
    private let gender: UILabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16)
    }
    private let birthday: UILabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16)
    }
    
    private var _model: CTPersonModel?
    var model: CTPersonModel? {
        willSet(newValue) {
            guard let value = newValue else {
                return
            }
            self._model = value
            self.icon.kf.setImage(with: URL(string: value.thumbnail))
            self.name.text = value.fullName()
            self.gender.text = value.gender
            self.birthday.text = value.birthdayString()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.icon)
        self.icon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(70)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(self.name)
        self.name.snp.makeConstraints { (make) in
            make.top.equalTo(self.icon)
            make.left.equalTo(self.icon.snp.right).offset(10)
            make.height.equalTo(40)
        }
        
        self.contentView.addSubview(self.gender)
        self.gender.snp.makeConstraints { (make) in
            make.top.height.equalTo(self.name)
            make.left.equalTo(self.name.snp.right).offset(5)
            make.right.equalToSuperview().offset(-15)
        }
        
        self.contentView.addSubview(self.birthday)
        self.birthday.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.icon)
            make.left.right.equalTo(self.name)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
