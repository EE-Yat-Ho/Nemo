//
//  AlermCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/17.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class AlermCell: UITableViewCell {
    let label = UILabel().then {
        $0.text = "문제풀기 알람"
    }
    let timerButton = UIButton().then {
        $0.setTitle("00:00", for: .normal)
        $0.setImage(UIImage(named:"위로화살표"), for: .normal)
        //$0. 엣지 정해야함. 레이아웃 보고 정하쟝
    }
    let toggleButton = UIButton().then {
        $0.setImage(UIImage(named:"꺼진스위치"), for: .normal)
        $0.setImage(UIImage(named:"켜진스위치"), for: .selected)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupLayout() {
        contentView.addSubview(label)
        contentView.addSubview(timerButton)
        contentView.addSubview(toggleButton)
        
        label.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        toggleButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
        timerButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(toggleButton.snp.leading).offset(-10)
        }
        
    }
}
