//
//  TimeCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/16.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {
    let timeLabel = UILabel().then {
        $0.font = UIFont.handNormal()
    }
    let checkImage = UIImageView()
    let unCheckImage = UIImageView().then {
        $0.image = UIImage(systemName: "circle")
        $0.alpha = 0.5
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    func setupLayout() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(checkImage)
        contentView.addSubview(unCheckImage)
        
        timeLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        checkImage.snp.makeConstraints{
            $0.centerY.equalToSuperview().offset(-10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(30)
        }
        unCheckImage.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-30)
            $0.width.height.equalTo(20)
        }
    }
    
    func mappingData(index: Int, isCheck: Bool) {
        switch index {
        case 0:
            timeLabel.text = "일주일 전"
        case 1:
            timeLabel.text = "이주일 전"
        case 2:
            timeLabel.text = "한 달 전"
        case 3:
            timeLabel.text = "모든 문제"
        default:
            timeLabel.text = "index Error"
        }
        if isCheck {
            checkImage.image = UIImage(named: "틀린표시-파랑")
        } else {
            checkImage.image = nil
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
