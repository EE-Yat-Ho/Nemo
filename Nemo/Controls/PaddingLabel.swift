//
//  PaddingLabel.swift
//  Nemo
//
//  Created by 박영호 on 2021/03/10.
//  Copyright © 2021 Park young ho. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: Resource.Font.topPadding, left: 0,
                                  bottom: Resource.Font.bottomPadding, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += (Resource.Font.topPadding + Resource.Font.bottomPadding)
            contentSize.width += 0
            return contentSize
        }
    }
}
