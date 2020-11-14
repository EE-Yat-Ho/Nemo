//
//  MultipleChoiceQuestionAnswerCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/08/18.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol vcDelegate {
    func clickXButton(_ cell: MultipleChoiceQuestionAnswerCell)
    //func clickAnswerButton(_ cell: MultipleChoiceQuestionAnswerCell)
    func textFieldDidChangeSelection(_ cell: MultipleChoiceQuestionAnswerCell)
}

class MultipleChoiceQuestionAnswerCell: UITableViewCell {
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    //let num = UIImageView()
    
    let contents = UITextField().then {
        $0.placeholder = "Enter"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.autocorrectionType = UITextAutocorrectionType.no
        $0.keyboardType = UIKeyboardType.default
        $0.returnKeyType = UIReturnKeyType.done
        $0.clearButtonMode = UITextField.ViewMode.whileEditing
        $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
//    let answerButton = UIButton().then {
//        $0.setImage(UIImage(named: "정답"), for: .normal)
//        $0.setImage(UIImage(named: "오답"), for: .highlighted)
//    }
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "엑스_검정"), for: .normal)
        $0.setImage(UIImage(named: "오답"), for: .highlighted)
    }
    var index: Int = 0
    var right: Bool! = false
    var delegate: vcDelegate!
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupLayout() {
        //contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        //self.contentView.addSubview(num)
        contentView.addSubview(contents)
        //self.contentView.addSubview(answerButton)
        contentView.addSubview(xButton)
        
//        num.snp.makeConstraints{
//            $0.centerY.equalToSuperview()
//            $0.leading.equalToSuperview().offset(10)
//            $0.width.equalTo(25)
//            $0.height.equalTo(30)
//        }
        contents.snp.makeConstraints{
            $0.centerY.leading.equalToSuperview()
            //$0.leading.equalTo(num.snp.trailing).offset(10)
            $0.trailing.equalTo(xButton.snp.leading).offset(-10)
            //$0.trailing.equalTo(answerButton.snp.leading).offset(-10)
        }
//        answerButton.snp.makeConstraints{
//            $0.centerY.equalToSuperview()
//            $0.trailing.equalTo(xButton.snp.leading).offset(-10)
//            $0.width.height.equalTo(35)
//        }
        xButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.height.equalTo(26)
        }
    }
    
    func mappingData(index: Int) {
        setupLayout()
        self.index = index
        //num.image = UIImage(named: "객관식번호_\(index + 1)")
        contents.text = DataManager.shared.answerList[index]
//        right = DataManager.shared.rightList[index]
//        if right {
//            answerButton.setImage(UIImage(named: "정답"), for: .normal)
//        } else {
//            answerButton.setImage(UIImage(named: "오답"), for: .normal)
//        }
        
        xButton.rx.tap.bind { [weak self] in
            self?.delegate.clickXButton(self!)
        }.disposed(by:disposeBag)
    
//        answerButton.rx.tap.bind { [weak self] in
//            self?.delegate.clickAnswerButton(self!)
//        }.disposed(by:disposeBag)
        
        contents.rx.text
            .distinctUntilChanged()
            .bind { [weak self] _ in // _ 여기에 newValue가 들어가네 호옹이
                self?.delegate?.textFieldDidChangeSelection(self!)
            }
            .disposed(by:disposeBag)
    }
}
