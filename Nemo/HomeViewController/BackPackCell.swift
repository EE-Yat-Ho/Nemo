//
//  BackPackCell.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/28.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import Then

class BackPackCell: UITableViewCell {
    let backPackImage = UIImageView().then {
        $0.image = UIImage(named: "가방")
    }
    let backPackName = UILabel()
    let numberOfNote = UILabel().then {
        $0.textColor = UIColor.gray
    }
    var rightImage = UIImageView()
    var aboveLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupLayout() {
        backgroundColor = UIColor.clear
        
        addSubview(backPackImage)
        addSubview(backPackName)
        addSubview(numberOfNote)
        addSubview(rightImage)
        addSubview(aboveLine)
        
        aboveLine.layer.borderColor = UIColor(displayP3Red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor
        aboveLine.layer.borderWidth = 1.0
        
        backPackImage.snp.makeConstraints{
            $0.height.width.equalTo(30)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        backPackName.snp.makeConstraints{
            //$0.height.width.equalTo(30)
            $0.leading.equalTo(backPackImage.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        numberOfNote.snp.makeConstraints{
            //$0.height.width.equalTo(30)
            $0.trailing.equalTo(rightImage.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        rightImage.snp.makeConstraints{
            $0.height.width.equalTo(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        aboveLine.snp.makeConstraints{
            $0.height.equalTo(1)
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
        }
        
        
    }
}
