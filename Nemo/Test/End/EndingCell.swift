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
        $0.font = UIFont.handNormal()
    }
//    let rightArrow = UIImageView().then {
//        $0.image = UIImage(named: "기본아이콘_이동")
//    }
    
    let isRightShape = UIImageView().then {
        $0.image = UIImage(named: "맞은표시-파랑") // "틀린표시"
    }
    let question = UITextView().then {
        $0.text = "1 + 1 = ?"
        $0.backgroundColor = UIColor.clear
        $0.isUserInteractionEnabled = false
        $0.font = UIFont.handNormal()
        //$0.font = UIFont(name: "NotoSansKannada-Regular", size: 17)
        // NSMutableAttributedString 써서 나중에 셀 데이터 매핑할 때 폰트 정함
    }
    
    let answerView = UIView().then{
        $0.backgroundColor = UIColor.clear
        $0.layer.borderWidth = 2.0
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 15.0
        $0.layer.masksToBounds = true
    }
    let myAnswerLabel = UILabel().then {
        $0.text = "내가 쓴 답"
        $0.textColor = .lightGray
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.clear
        $0.font = UIFont(name: "NotoSansKannada-Regular", size: 15)
    }
    let rightAnswerLabel = UILabel().then {
        $0.text = "정 답"
        $0.textColor = .lightGray
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.clear
        $0.font = UIFont(name: "NotoSansKannada-Regular", size: 15)
    }
    let separatorVector = UIView().then {
        $0.backgroundColor = .lightGray
    }
    let separatorHorizon = UIView().then {
        $0.backgroundColor = .lightGray
    }
    let myAnswerLabel2 = UILabel().then {
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.clear
        //$0.font = UIFont(name: "NotoSansKannada-Regular", size: 18)
        $0.font = UIFont.handNormal()
    }
    let rightAnswerLabel2 = UILabel().then {
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.clear
       // $0.font = UIFont(name: "NotoSansKannada-Regular", size: 18)
        $0.font = UIFont.handNormal()
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
        //contentView.addSubview(rightArrow)
        contentView.addSubview(isRightShape)
        contentView.addSubview(question)
        contentView.addSubview(answerView)
        answerView.addSubview(myAnswerLabel)
        answerView.addSubview(rightAnswerLabel)
        answerView.addSubview(separatorVector)
        answerView.addSubview(separatorHorizon)
        answerView.addSubview(myAnswerLabel2)
        answerView.addSubview(rightAnswerLabel2)
        
        separator.snp.makeConstraints{
            $0.height.equalTo(2)
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        isRightImage.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.width.equalTo(45)
            $0.top.equalTo(separator.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
//        rightArrow.snp.makeConstraints{
//            $0.centerY.equalToSuperview()
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.height.width.equalTo(20)
//        }
        question.snp.makeConstraints{
            $0.top.equalTo(isRightImage.snp.top)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(isRightImage.snp.leading).offset(-20)
            $0.height.equalTo(80)
        }
        isRightShape.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.height.width.equalTo(60)
        }
        answerView.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(60)
        }
        myAnswerLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(3)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(answerView.snp.centerX)
            $0.height.equalTo(21)
        }
        rightAnswerLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(3)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(answerView.snp.centerX)
            $0.height.equalTo(21)
        }
        separatorVector.snp.makeConstraints{
            $0.width.equalTo(2)
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        separatorHorizon.snp.makeConstraints{
            $0.height.equalTo(2)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        myAnswerLabel2.snp.makeConstraints{
            $0.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(answerView.snp.centerX)
            $0.top.equalTo(separatorHorizon.snp.bottom)
        }
        rightAnswerLabel2.snp.makeConstraints{
            $0.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(answerView.snp.centerX)
            $0.top.equalTo(separatorHorizon.snp.bottom)
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
        
        question.text = "\(index + 1). " + DataManager.shared.testQuestionList[index].question!
        myAnswerLabel2.text = DataManager.shared.testAnswerList[index]
        rightAnswerLabel2.text = DataManager.shared.testQuestionList[index].answer
        
        /// 전체폰트 + 부분폰트 지정
        let bigNumFont = UIFont.boldSystemFont(ofSize: 20)
        let normalFont = UIFont.handNormal()
        
        let attributedStr = NSMutableAttributedString(string: question.text)
        attributedStr.addAttribute(.font,
                                   value: normalFont,
                                   range: (question.text! as NSString).range(of: question.text))
        attributedStr.addAttribute(.font,
                                   value: bigNumFont,
                                   range: (question.text! as NSString).range(of: "\(index + 1)."))
        question.attributedText = attributedStr
    }
}
