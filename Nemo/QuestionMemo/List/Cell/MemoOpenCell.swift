//
//  MemoOpenCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/10/12.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MemoOpenCell: UITableViewCell {
    let memoImage = UIImageView().then {
        $0.image = UIImage(named: "필기")
    }
    let memoLabel = UILabel().then {
        $0.text = "필기 보기"
    }
    let numberOfMemo = UILabel().then {
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
        backgroundColor = UIColor.clear
        setupLayout()
    }
    
    func setupLayout() {
        backgroundColor = UIColor.clear
        
        addSubview(memoImage)
        addSubview(memoLabel)
        addSubview(numberOfMemo)
        addSubview(rightImage)
        addSubview(aboveLine)
        
        aboveLine.layer.borderColor = UIColor(displayP3Red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor
        aboveLine.layer.borderWidth = 1.0
        
        memoImage.snp.makeConstraints{
            $0.height.width.equalTo(30)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        memoLabel.snp.makeConstraints{
            //$0.height.width.equalTo(30)
            $0.leading.equalTo(memoImage.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        numberOfMemo.snp.makeConstraints{
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
