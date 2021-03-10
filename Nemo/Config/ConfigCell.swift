//
//  IncorrectQuestionCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/17.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class ConfigCell: UITableViewCell {
    let icon = UIImageView()
    let label = UILabel().then {
        $0.font = UIFont.handNormal()
    }
    let rightArrow = UIImageView().then {
        $0.image = UIImage(named: "arrow_right")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func mappingData(index: Int) {
        switch index {
        case 0:
            icon.image = UIImage(named: "alarm")
            label.text = "알림"
        case 1:
            icon.image = UIImage(named: "backup")
            label.text = "백업 (개발중)"
        case 2:
            icon.image = UIImage(named: "company")
            label.text = "사용법"
        case 3:
            icon.image = UIImage(named: "grenn_i")
            label.text = "개발자 이메일 문의"
        case 4:
            icon.image = UIImage(named: "blacki")
            label.text = "폰트 설정"
        default:
            print("error")
        }
    }

    func setupLayout() {
        backgroundColor = UIColor.clear
        
        contentView.addSubview(icon)
        contentView.addSubview(label)
        contentView.addSubview(rightArrow)
        
        icon.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(30)
        }
        label.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(icon.snp.trailing).offset(8)
        }
        rightArrow.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(20)
        }
    }
}
