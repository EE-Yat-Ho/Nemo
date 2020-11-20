//
//  UIViewController+Alert.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/06/23.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

extension UIViewController {// 상속하는 모든 뷰 컨트롤러들이 여기의 함수를 사용할 수 있게 익스텐션으로 선언
    func alert(title: String = "알림", message: String) {// 제목과 내용을 받아서 알림을 띄우는 함수 ( 제목 기본값은 "알림" )
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) // 알림창 객체 생성
        
        let okAction = UIAlertAction(title: "확인",  style: .default, handler: nil) // 버튼 객체 생성
        alert.addAction(okAction) // 알림창에 버튼 객체 추가
        
        present(alert, animated: true, completion: nil) // 완성된 알림창 화면에 띄우기
    }
}
