//
//  MemoCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/10/12.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MemoCell: UITableViewCell {
    var memoTitle = UILabel().then {
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
        contentView.addSubview(memoTitle)
        memoTitle.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
