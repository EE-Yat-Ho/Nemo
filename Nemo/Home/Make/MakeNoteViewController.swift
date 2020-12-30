//
//  MakeNoteViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/27.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit
import RxSwift

class MakeNoteViewController: UIViewController {
    
    var naviBar = UINavigationBar()
    var naviItem = UINavigationItem().then{
        $0.title = "노트 만들기"
    }
    var saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(save)).then{
        $0.title = "저장"
    }
    var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: #selector(cancel)).then{
        $0.title = "취소"
    }
    
    var noteNameLabel = UILabel().then{
        $0.text = "노트 이름"
    }
    var noteName = UITextField().then{
        $0.placeholder = "노트 이름 입력"
        //$0.font = UIFont.systemFont(ofSize: 14)
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.autocorrectionType = UITextAutocorrectionType.no
        $0.keyboardType = UIKeyboardType.default
        $0.returnKeyType = UIReturnKeyType.done
        $0.clearButtonMode = UITextField.ViewMode.whileEditing
        $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        $0.font = UIFont.handNormal()
    }
    // 넣을 가방 선택용 드랍다운버튼
    var dropDownButton = DropDownButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0)).then{
        $0.setTitle("가방 선택", for: .normal)
        $0.titleLabel?.font = UIFont.handNormal()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        // 커서 초기화
        noteName.becomeFirstResponder()
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
        view.addSubview(noteNameLabel)
        view.addSubview(noteName)
        view.addSubview(dropDownButton)
        
        naviItem.setLeftBarButton(cancelButton, animated: true)
        naviItem.setRightBarButton(saveButton, animated: true)
        naviBar.setItems([naviItem], animated: true)
        
        naviBar.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        noteNameLabel.snp.makeConstraints{
            $0.top.equalTo(naviBar.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        noteName.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(noteNameLabel.snp.bottom).offset(10)
            $0.height.equalTo(34)
        }
        dropDownButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(noteName.snp.bottom).offset(10)
            $0.height.equalTo(34)
        }
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    @objc func save() {
        //메모 갈아거 0이면 메모 입력하세요 띄우기
        guard let name = noteName.text, name.count > 0 else{
            alert(message: "노트 이름을 입력하세요")
            return
        }
        if dropDownButton.isChanged == false {
            alert(message: "넣을 가방을 선택해주세요")
            return
        }
        //DataManager.shared.fetchNote(backPackName: dropDownButton.titleLabel?.text)
        if DataManager.shared.safetyNoteOverLap(name: name) == false{
            alert(message: "같은 이름의 노트가 이미 있어요.")
            return
        }
        DataManager.shared.addNewNote(noteName: name, backPackName: dropDownButton.titleLabel?.text) // 20200621 #19 db구현2. 위에것들 주석처리하고, 새로 작성한 디비 저장함수 실행
        DataManager.shared.homeViewTableReloadTrigger.accept(())
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
