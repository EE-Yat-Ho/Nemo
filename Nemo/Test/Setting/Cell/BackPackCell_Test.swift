//
//  BackPackCell_Test.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/16.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import Then

class BackPackCell_Test: UITableViewCell {
    
    let backPackImage = UIImageView().then {
        $0.image = UIImage(named: "backpack_main")
    }
    let backPackName = UILabel().then {
        $0.font = UIFont.handNormal()
    }
    let numberOfNote = UILabel().then {
        $0.textColor = UIColor.gray
        $0.font = UIFont.handNormal()
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
    
    func mappingData(index:Int){
        backPackName.text = DataManager.shared.backPackList[index].name
        numberOfNote.text = "노트 " + String(DataManager.shared.backPackList[index].numberOfNote)
        if DataManager.shared.backPackList[index].opened == true {
            rightImage.image = UIImage(named: "arrow_down")
        } else {
            rightImage.image = UIImage(named: "arrow_left")
        }
    }
    
    func setupLayout() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        addSubview(backPackImage)
        addSubview(backPackName)
        addSubview(numberOfNote)
        addSubview(rightImage)
        addSubview(aboveLine)
        
        numberOfNote.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        numberOfNote.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        
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
            $0.trailing.equalTo(numberOfNote.snp.leading).offset(-20)
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
