//
//  CollectionViewCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/02.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

protocol CollectionDelegate {
    func clickXButton(_ cell: CollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView().then{
        $0.image = UIImage(named: "가방")
        $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.black
    }
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "엑스_하양회색"), for: .normal)
    }
    var delegate: CollectionDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(xButton)
        
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(5)
        }
        xButton.snp.makeConstraints{
            $0.top.trailing.equalToSuperview().inset(5)
            $0.height.width.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
