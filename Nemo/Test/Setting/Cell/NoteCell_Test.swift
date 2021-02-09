//
//  NoteCell_Test.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/16.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import Then

class NoteCell_Test: UITableViewCell {
    var checkImage = UIImageView().then{
        $0.image = UIImage(named: "fail_blue")
        $0.isHidden = true
    }
    var noteImage = UIImageView().then {
        $0.image = UIImage(named: "note_main")
    }
    var noteName = UILabel().then {
        $0.font = UIFont.handNormal()
    }
    var numberOfQuestion = UILabel().then {
        $0.textColor = UIColor.gray
        $0.font = UIFont.handNormal()
    }
    var numberOfMemo = UILabel().then {
        $0.textColor = UIColor.gray
        $0.font = UIFont.handNormal()
    }
    var rightImage = UIImageView()
        //.then {
        //$0.image = UIImage(named: "arrow_right")
    //}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func mappingData(indexPath: IndexPath, isCheck: Bool){
        noteName.text = DataManager.shared.noteList[indexPath.section][indexPath.row - 1].name
        numberOfQuestion.text = "문제 " + String(DataManager.shared.noteList[indexPath.section][indexPath.row - 1].numberOfQ)
        numberOfMemo.text = "필기 " + String(DataManager.shared.noteList[indexPath.section][indexPath.row - 1].numberOfM)
        if isCheck {
            checkImage.isHidden = false
        } else {
            checkImage.isHidden = true
        }
    }
    
    func setupLayout() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        addSubview(checkImage)
        addSubview(noteImage)
        addSubview(noteName)
        addSubview(numberOfQuestion)
        addSubview(numberOfMemo)
        addSubview(rightImage)
        
        numberOfQuestion.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        numberOfQuestion.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        
        numberOfMemo.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        numberOfMemo.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        
        checkImage.snp.makeConstraints{
            $0.edges.equalTo(noteImage).inset(-10)
        }
        noteImage.snp.makeConstraints{
            $0.height.width.equalTo(30)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        noteName.snp.makeConstraints{
            //$0.height.width.equalTo(30)
            $0.leading.equalTo(noteImage.snp.trailing).offset(10)
            $0.trailing.equalTo(numberOfMemo.snp.leading).offset(-20)
            $0.centerY.equalToSuperview()
        }
        numberOfMemo.snp.makeConstraints{
            //$0.height.width.equalTo(30)
            $0.trailing.equalTo(numberOfQuestion.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        numberOfQuestion.snp.makeConstraints{
            //$0.height.width.equalTo(30)
            $0.trailing.equalTo(rightImage.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        rightImage.snp.makeConstraints{
            $0.height.width.equalTo(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
}
