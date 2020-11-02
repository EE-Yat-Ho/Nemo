//
//  CollectionViewCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/02.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView().then{
        $0.image = UIImage(named: "가방")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        imageView.layer.borderWidth = 1.0
        imageView.layer.cornerRadius = 5.0
        
        imageView.backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
