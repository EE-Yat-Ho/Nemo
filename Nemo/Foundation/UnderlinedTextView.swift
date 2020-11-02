//
//  UnderlinedTextView.swift
//  Nemo
//
//  Created by 박영호 on 2020/10/30.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class UnderlinedTextView: UITextView {
     var lineHeight: CGFloat = 13.8

     override var font: UIFont? {
       didSet {
         if let newFont = font {
           lineHeight = newFont.lineHeight
         }
       }
     }

     override func draw(_ rect: CGRect) {
       let ctx = UIGraphicsGetCurrentContext()

       let numberOfLines = Int(rect.height / lineHeight)
       let topInset = textContainerInset.top

       for i in 1...numberOfLines {
         let y = topInset + CGFloat(i) * lineHeight

         let line = CGMutablePath()
         line.move(to: CGPoint(x: 0.0, y: y))
         line.addLine(to: CGPoint(x: rect.width, y: y))
         ctx?.addPath(line)
       }

       ctx?.strokePath()

       super.draw(rect)
     }
}
