//
//  MakeBackPackViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/23.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MakeBackPackViewController: UIViewController {
    var naviBar = UINavigationBar()
    var naviItem = UINavigationItem().then{
        $0.title = "가방 만들기"
    }
    var saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(save)).then{
        $0.title = "저장"
    }
    var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: #selector(cancel)).then{
        $0.title = "취소"
    }
    
    var backPackNameLabel = UILabel().then{
        $0.text = "가방 이름"
    }
    var backPackName = UITextField().then{
        $0.placeholder = "가방 이름 입력"
        //$0.font = UIFont.systemFont(ofSize: 14)
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.autocorrectionType = UITextAutocorrectionType.no
        $0.keyboardType = UIKeyboardType.default
        $0.returnKeyType = UIReturnKeyType.done
        $0.clearButtonMode = UITextField.ViewMode.whileEditing
        $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        $0.font = UIFont.handNormal()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        backPackName.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardwillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func KeyBoardwillShow(_ noti : Notification ){
        let keyboardHeight = ((noti.userInfo as! NSDictionary).value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.height
        UserDefaults.standard.setValue(keyboardHeight, forKey: "keyboardHeight")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func setupLayout() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(naviBar)
        view.addSubview(backPackNameLabel)
        view.addSubview(backPackName)
        
        naviItem.setLeftBarButton(cancelButton, animated: true)
        naviItem.setRightBarButton(saveButton, animated: true)
        naviBar.setItems([naviItem], animated: true)
        
        naviBar.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        backPackNameLabel.snp.makeConstraints{
            $0.top.equalTo(naviBar.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        backPackName.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(backPackNameLabel.snp.bottom).offset(10)
            $0.height.equalTo(34)
        }
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func save(_ sender: Any) {
        //메모 갈아거 0이면 메모 입력하세요 띄우기
        guard let name = backPackName.text, name.count > 0 else{
           alert(message: "가방 이름을 입력하세요.")
           return
        }
        
        if DataManager.shared.safetyBackPackOverLap(name: name) == false{
            alert(message: "같은 이름의 가방이 이미 있어요.")
            return
        }
        DataManager.shared.addNewBackPack(name: name)
        DataManager.shared.homeViewTableReloadTrigger.accept(())
        
        dismiss(animated: true, completion: nil)
    }
}


