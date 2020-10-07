//
//  MakeBackPackViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/23.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MakeBackPackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "완료",
                            style: UIBarButtonItem.Style.plain,
                            target: nil,
                            action: #selector(save(_:)))
        backpackName.becomeFirstResponder()
    }

    @IBOutlet weak var backpackName: UITextField!
    @objc private func save(_ sender: Any) {
        //메모 갈아거 0이면 메모 입력하세요 띄우기
        guard let name = backpackName.text, name.count > 0 else{
           alert(message: "가방 이름을 입력하세요.")
           return
        }
        
        if DataManager.shared.safetyBackPackOverLap(name: name) == false{
            alert(message: "같은 이름의 가방이 이미 있어요.")
            return
        }
        //#20
        //if let target = editTarget{ // 아래랑 마찬가지로, editTarget속성에 뭔가 들어있다면 그대로 디비 저장 아니라면 새메모추가
        //target.name = name
        //DataManager.shared.saveContext()
        DataManager.shared.addNewBackPack(name: name) // 20200621 #19 db구현2. 위에것들 주석처리하고, 새로 작성한 디비 저장함수 실행
        NotificationCenter.default.post(name:MakeBackPackViewController.newBackPackDidInsert, object: nil) // 앱의 모든 객체에게 노티피케이션을 전달
        //}else{
        navigationController?.popViewController(animated: true)
    }

}

// appear을 자동으로 호출하지 않는 것을 노티피케이션으로 해결. 모든 객체에게 노티피케이션을 쏴주고, 옵저버를 통해 노티피케이션의 이름으로 해당 노티피케이션을 수신하는 방식
// 모든 객체에 노티피케이션을 쏴주는 것을 노티피케이션 센터에서 함
extension MakeBackPackViewController {
    static let newBackPackDidInsert = Notification.Name(rawValue:"newBackPackDidInsert")
}
