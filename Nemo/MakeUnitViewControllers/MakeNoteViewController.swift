//
//  MakeNoteViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/27.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MakeNoteViewController: UIViewController {
    
    // 넣을 가방 선택용 드랍다운버튼
    var button = DropDownButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.setTitle("가방 선택", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false // 제약 자동화는 꺼놓고
        self.view.addSubview(button) // 버튼을 뷰에 따란~
        
        // 수동으로 제약 지정해주기
        button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        //button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        //button.dropView.DropDownOption = ["Hello", "World"]
        
//        self.navigationItem.rightBarButtonItem =
//            UIBarButtonItem(title: "완료",
//                            style: UIBarButtonItem.Style.plain,
//                            target: nil,
//                            action: #selector(save(_:)))
        NoteName.becomeFirstResponder()
    }
    
    @IBOutlet weak var NoteName: UITextField!
//    @objc private func save(_ sender: Any) {
//        //메모 갈아거 0이면 메모 입력하세요 띄우기
//        guard let name = NoteName.text, name.count > 0 else{
//            alert(message: "노트 이름을 입력하세요")
//            return
//        }
//        if button.isChanged == false {
//            alert(message: "넣을 가방을 선택해주세요")
//            return
//        }
//        DataManager.shared.fetchNote(backPackName: button.titleLabel?.text)
//        if DataManager.shared.safetyNoteOverLap(name: name) == false{
//            alert(message: "해당 가방에 같은 이름의 노트가 이미 있어요.")
//            return
//        }
//        DataManager.shared.addNewNote(noteName: name, backPackName: button.titleLabel?.text) // 20200621 #19 db구현2. 위에것들 주석처리하고, 새로 작성한 디비 저장함수 실행
//        NotificationCenter.default.post(name:MakeBackPackViewController.newBackPackDidInsert, object: nil) // 앱의 모든 객체에게 노티피케이션을 전달
//        //}else{
//
//        navigationController?.popViewController(animated: true)
//    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        //메모 갈아거 0이면 메모 입력하세요 띄우기
        guard let name = NoteName.text, name.count > 0 else{
            alert(message: "노트 이름을 입력하세요")
            return
        }
        if button.isChanged == false {
            alert(message: "넣을 가방을 선택해주세요")
            return
        }
        DataManager.shared.fetchNote(backPackName: button.titleLabel?.text)
        if DataManager.shared.safetyNoteOverLap(name: name) == false{
            alert(message: "해당 가방에 같은 이름의 노트가 이미 있어요.")
            return
        }
        DataManager.shared.addNewNote(noteName: name, backPackName: button.titleLabel?.text) // 20200621 #19 db구현2. 위에것들 주석처리하고, 새로 작성한 디비 저장함수 실행
        NotificationCenter.default.post(name:MakeBackPackViewController.newBackPackDidInsert, object: nil) // 앱의 모든 객체에게 노티피케이션을 전달
        //}else
        dismiss(animated: true, completion: nil)
    }
    
    
}
