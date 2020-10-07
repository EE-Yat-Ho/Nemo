//
//  RoundButton.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/23.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    // MARK: - UI
       
    func setupUI() {
        //색상
        tintColor = UIColor.white
        if backgroundImage(for: .normal) == nil {
            backgroundColor = UIColor(red:0.15,  green:0.50,  blue:1.0, alpha:1)
        }

        //형태
        layer.cornerRadius = frame.width/2
        layer.masksToBounds = true

        //이미지 인셋
        let inset: CGFloat = 10
        imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset);
    }
       
       
    // MARK: - Init

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    convenience init(image: UIImage?, backgroundColor: UIColor = UIColor(red:0.086,  green:0.357,  blue:0.553, alpha:1)) {
        self.init()
        setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
