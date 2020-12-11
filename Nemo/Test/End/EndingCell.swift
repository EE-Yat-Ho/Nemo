//
//  EndingCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/08/11.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class EndingCell: UITableViewCell {

    let separator = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.5)
    }
    let isRightImage = UILabel().then {
        $0.text = "정답"
        $0.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 5
        $0.textAlignment = .center
        //$0.image = UIImage(named: "정답")
        //$0.backgroundColor = UIColor.clear
    }
    let rightArrow = UIImageView().then {
        $0.image = UIImage(named: "기본아이콘_이동")
    }
    
    let isRightShape = UIImageView().then {
        $0.image = UIImage(named: "맞은표시-파랑") // "틀린표시"
    }
    let bigNum = UILabel().then {
        $0.text = "1."
        $0.font = UIFont(name: "NotoSansKannada-Bold", size: 22)
        $0.textAlignment = .center
    }
    let question = UITextView().then {
        $0.text = "1 + 1 = ?"
        $0.backgroundColor = UIColor.clear
        $0.isUserInteractionEnabled = false
        $0.font = UIFont(name: "NotoSansKannada-Regular", size: 17)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupLayout() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(separator)
        contentView.addSubview(isRightImage)
        contentView.addSubview(rightArrow)
        contentView.addSubview(isRightShape)
        contentView.addSubview(bigNum)
        contentView.addSubview(question)
        
        separator.snp.makeConstraints{
            $0.height.equalTo(2)
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        isRightImage.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.width.equalTo(45)
            $0.top.equalTo(separator.snp.bottom).offset(20)
            $0.trailing.equalTo(rightArrow.snp.leading).offset(-10)
        }
        rightArrow.snp.makeConstraints{
            $0.centerY.equalTo(isRightImage)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.width.equalTo(20)
        }
        bigNum.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalTo(isRightImage.snp.bottom).offset(30)
            $0.width.equalTo(34)
            $0.height.equalTo(25)
        }
        question.snp.makeConstraints{
            $0.top.equalTo(bigNum).offset(-7)
            $0.leading.equalTo(bigNum).offset(3)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        isRightShape.snp.makeConstraints{
            $0.edges.equalTo(bigNum).inset(-25)
        }
    }
    
    func mappingData(index: Int, isRight: Bool) {
        if isRight {
            isRightImage.text = "정답"
            isRightImage.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
            isRightImage.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
            isRightShape.image = UIImage(named: "맞은표시-파랑")
        } else {
            isRightImage.text = "오답"
            isRightImage.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            isRightImage.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            isRightShape.image = UIImage(named: "틀린표시")
        }
        
        bigNum.text = String(index + 1) + "."
        question.text = "    " + DataManager.shared.testQuestionList[index].question!
    }
}
