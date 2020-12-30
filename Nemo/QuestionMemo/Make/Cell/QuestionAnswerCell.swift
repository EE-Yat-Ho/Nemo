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

protocol QuestionAnswerDelegate {
    func clickXButton(_ cell: QuestionAnswerCell)
    func textFieldDidChangeSelection(_ cell: QuestionAnswerCell)
}

class QuestionAnswerCell: UITableViewCell {
    
    let contents = UITextField().then {
        $0.placeholder = "입력해주세요."
        //$0.font = UIFont.systemFont(ofSize: 15)
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.autocorrectionType = UITextAutocorrectionType.no
        $0.keyboardType = UIKeyboardType.default
        $0.returnKeyType = UIReturnKeyType.done
        $0.clearButtonMode = UITextField.ViewMode.whileEditing
        $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.font = UIFont.handNormal()
    }
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "엑스_검정"), for: .normal)
    }
    var index: Int = 0
    var delegate: QuestionAnswerDelegate!
    var disposeBag = DisposeBag()
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupLayout() {
        backgroundColor = UIColor.clear
        
        contentView.addSubview(contents)
        contentView.addSubview(xButton)
        
        contents.snp.makeConstraints{
            $0.centerY.leading.equalToSuperview()
            $0.trailing.equalTo(xButton.snp.leading).offset(-10)
        }
        xButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.height.equalTo(26)
        }
    }
    
    func mappingData(index: Int, isSubjective: Bool) {
        setupLayout()
        self.index = index
        contents.text = DataManager.shared.answerList[index]
        
        if isSubjective {
            contents.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
            contents.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 0.2)
        } else {
            contents.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            contents.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.2)
        }
        
        xButton.rx.tap.bind { [weak self] in
            self?.delegate.clickXButton(self!)
        }.disposed(by:disposeBag)
        
        contents.rx.text
            .distinctUntilChanged()
            .bind { [weak self] _ in // _ 여기에 newValue가 들어가네 호옹이
                self?.delegate?.textFieldDidChangeSelection(self!)
            }
            .disposed(by:disposeBag)
    }
}
