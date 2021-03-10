//
//  AnswerCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/16.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol TestAnswerDelegate {
    func clickXButton(_ cell: TestAnswerCell)
}

class TestAnswerCell: UITableViewCell {

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    var index = -1
    var delegate: TestAnswerDelegate!
    var disposeBag = DisposeBag()
    
    let numImage = UIImageView()
    let checkImage = UIImageView().then {
        $0.image = UIImage(named:"fail_blue")
    }
    let label = UILabel().then {
        $0.font = UIFont.handNormal()
        $0.numberOfLines = 0
    }
    let cancelLine = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.7371307791)
    }
    let xButton = UIButton().then {
        $0.setImage(UIImage(named:"x_white"), for: .normal)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        updateConstraints()
//    }
    
    func mappingDate(index: Int, isCheck: Bool, isExclusion: Bool) {
        setupLayout()
        self.index = index
        checkImage.isHidden = !isCheck
        cancelLine.isHidden = !isExclusion
        if isExclusion {
            xButton.setImage(UIImage(named:"rollback"), for: .normal)
        } else {
            xButton.setImage(UIImage(named:"x_white"), for: .normal)
        }
        
        numImage.image = UIImage(systemName: String(index + 1) + ".circle")
        label.text = DataManager.shared.orderingAnswers[DataManager.shared.nowQNumber! - 1][index]
        
        xButton.rx.tap.bind { [weak self] in
            self?.delegate.clickXButton(self!)
        }.disposed(by:disposeBag)
        
    }
    
    func setupLayout() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(numImage)
        contentView.addSubview(checkImage)
        contentView.addSubview(label)
        contentView.addSubview(cancelLine)
        contentView.addSubview(xButton)
        
        numImage.snp.makeConstraints{
            $0.top.equalTo(label).offset(2.5)
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(23.5)
        }
        checkImage.snp.makeConstraints{
            $0.edges.equalTo(numImage).inset(-10)
        }
        label.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(numImage.snp.trailing).offset(8)
            $0.trailing.equalTo(xButton.snp.leading).offset(-8)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        cancelLine.snp.makeConstraints{
            $0.centerY.equalTo(numImage)
            $0.leading.equalTo(numImage.snp.leading).offset(-3)
            $0.trailing.equalTo(label).offset(3)
            $0.height.equalTo(2)
        }
        xButton.snp.makeConstraints{
            $0.centerY.equalTo(numImage)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.width.equalTo(20)
        }
    }

}
