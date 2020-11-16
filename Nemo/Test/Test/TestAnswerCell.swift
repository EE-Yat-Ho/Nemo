//
//  AnswerCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/16.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class TestAnswerCell: UITableViewCell {

    let numImage = UIImageView()
    let checkImage = UIImageView().then {
        $0.image = UIImage(named:"틀린표시-파랑")
    }
    let label = UILabel()
    let cancelLine = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    let xButton = UIButton().then {
        $0.setImage(UIImage(named:"엑스_하양회색"), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func mappingDate(index: Int, isCheck: Bool, isExclusion: Bool) {
        checkImage.isHidden = false//!isCheck
        cancelLine.isHidden = false//!isExclusion
        numImage.image = UIImage(systemName: String(index) + ".circle")
        label.text = DataManager.shared.orderingAnswers[DataManager.shared.nowQNumber! - 1][index]
    }
    
    func setupLayout() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        
        
        contentView.addSubview(numImage)
        contentView.addSubview(checkImage)
        contentView.addSubview(label)
        contentView.addSubview(cancelLine)
        contentView.addSubview(xButton)
        
        numImage.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(30)
        }
        checkImage.snp.makeConstraints{
            $0.edges.equalTo(numImage)
        }
        label.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(numImage.snp.trailing)
        }
        cancelLine.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalTo(label)
        }
        xButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
