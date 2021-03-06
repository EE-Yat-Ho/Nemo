//
//  CollectionViewCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/11/02.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CollectionDelegate {
    func clickXButton(_ cell: CollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView().then{
        $0.image = UIImage(named: "backpack_main")
        $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.black
        $0.contentMode = .scaleAspectFit
    }
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "x_white"), for: .normal)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    var index: Int = -1
    var collectionTag: Int = -1
    var delegate: CollectionDelegate!
    var disposeBag = DisposeBag()
    
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
    
    func mappingData(index:Int, tag:Int){
        self.index = index
        collectionTag = tag
        if tag == 1 {
            imageView.image = DataManager.shared.imageList[index]
        } else {
            imageView.image = DataManager.shared.imageList2[index]
        }
        xButton.rx.tap.bind { [weak self] in
            self?.delegate.clickXButton(self!)
        }.disposed(by:disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
