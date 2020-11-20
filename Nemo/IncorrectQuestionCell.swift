//
//  IncorrectQuestionCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/17.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class IncorrectQuestionCell: UITableViewCell {
    let questionTitle = UILabel()
    let numLabel = UILabel().then {
        $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        $0.font = .systemFont(ofSize: 13)
    }
    let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func mappingData(index: Int, key: SortKey) {
        questionTitle.text = DataManager.shared.sortQuestionList[index].question
        switch key {
        case .failCount:
            numLabel.text = "틀린 횟수 : \(DataManager.shared.sortQuestionList[index].failCount)"
        case .failDate:
            numLabel.text = "틀린 시간 : " +
                dateFormatter.string(from: DataManager.shared.sortQuestionList[index].failDate!)
        }
    }
    
    func setupLayout() {
        backgroundColor = UIColor.clear
        contentView.addSubview(questionTitle)
        contentView.addSubview(numLabel)
        questionTitle.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        numLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
