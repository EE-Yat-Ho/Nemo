//
//  MultipleChoiceQuestionAnswerCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/08/18.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MultipleChoiceQuestionAnswerCell: UITableViewCell {
    let num = UIImageView()
    
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
    let answerButton = UIButton().then {
        $0.setImage(UIImage(named: "정답"), for: .normal)
    }
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "엑스_검정"), for: .normal)
    }
    var index: Int = 0
    var right: Bool! = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupLayout() {
        contentView.addSubview(num)
        contentView.addSubview(contents)
        contentView.addSubview(answerButton)
        contentView.addSubview(xButton)
        
        num.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(25)
            $0.height.equalTo(30)
        }
        contents.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(num.snp.trailing).offset(10)
            $0.trailing.equalTo(answerButton.snp.leading).offset(-10)
        }
        answerButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(xButton.snp.leading).offset(-10)
            $0.width.height.equalTo(35)
        }
        xButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.height.equalTo(26)
        }
        
    }
    
    func mappingData(index: Int) {
        setupLayout()
        num.image = UIImage(named: "객관식번호_\(index + 1)")
        
        answerButton.rx.tap.bind
        
        xButton.rx.tap.bind { [weak self] in
            self?.delegate.tapXButton(self!)
        }.disposed(by:disposeBag)
        
        answerTextField.rx.text
            .distinctUntilChanged()
            .bind { [weak self] _ in // _ 여기에 newValue가 들어가네 호옹이
                self?.delegate?.textFieldDidChangeSelection(self!)
        }.disposed(by:disposeBag)
    }

    @objc func clickAnswerButton() {
        if right {
            answerButton.setImage(UIImage(named: "오답"), for: .normal)
        } else {
            answerButton.setImage(UIImage(named: "정답"), for: .normal)
        }
        right.toggle()
        DataManager.shared.rightList[index].toggle()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
