//
//  DropDownButton.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/27.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

protocol DropDownProtocol {
    func DropDownPressed(string: String)
}


class DropDownButton: UIButton, DropDownProtocol {
    func DropDownPressed(string: String){
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
        isChanged = true
    }
    
    var isChanged : Bool = false
    var dropView = DropDownView()
    var height = NSLayoutConstraint()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.systemBlue
        dropView = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        // 아니 이거 버튼 해제당할때는 왜 불려가지고 ㅅㅂ 슈퍼 뷰가 닐일때는 해제당할때임 그래서 안해제할때만 실행
        if superview != nil {
            self.superview?.addSubview(dropView)
            self.superview?.bringSubviewToFront(dropView)
            
            dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            height = dropView.heightAnchor.constraint(equalToConstant: 10)
        }
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func dismissDropDown(){
        isOpen = false
        
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
