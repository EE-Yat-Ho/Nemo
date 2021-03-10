//
//  ToastManager.swift
//  Nemo
//
//  Created by 박영호 on 2021/03/10.
//  Copyright © 2021 Park young ho. All rights reserved.
//

import UIKit
import SnapKit

class ToastManager {
    class func showToast (/*vc: UIViewController? = nil, */message: String) {
        DispatchQueue.main.async {
            let sideMargin: CGFloat = 16
            
            let container: UIView = UIView().then {
                $0.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                $0.layer.cornerRadius = 12
                $0.layer.masksToBounds = true
                $0.alpha = 0.8
            }
            
            let toastLabel: UILabel = UILabel().then {
                //$0.font = .handNormal()
                $0.textColor = .white
                $0.textAlignment = .center
                $0.text = message
                $0.numberOfLines = 0
            }
            
//            var buf: UIView? = nil
//            if vc != nil {
//                buf = vc?.view
//            } else {
//                buf = UIApplication.shared.keyWindow
//            }
//            guard let top = buf else { return }
            guard let top = UIApplication.shared.keyWindow else { return }
            
            top.addSubview(container)
            container.addSubview(toastLabel)
            
            container.snp.makeConstraints {
                $0.trailing.leading.equalToSuperview().inset(sideMargin)
                $0.bottom.equalTo(top.safeAreaLayoutGuide).offset(150)
            }
            toastLabel.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(sideMargin)
            }
            
            UIView.animate(withDuration: 0.1, delay: 0, animations: {
                // 일단 밑에 레이아웃하기 위한 버퍼 애니메이션
                container.alpha = 1
            },
            completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    // 위로 올리기
                    container.snp.updateConstraints {
                        $0.bottom.equalTo(top.safeAreaLayoutGuide).offset(-80)
                    }
                    container.superview?.layoutIfNeeded()
                }, completion: { _ in
                    // 여기 딜레이가 떠있는 시간
                    UIView.animate(withDuration: 1, delay: 1.5, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                        // 밑으로 내리기
                        container.snp.updateConstraints {
                            $0.bottom.equalTo(top.safeAreaLayoutGuide).offset(150)
                        }
                        container.superview?.layoutIfNeeded()
                    }, completion: { _ in
                        container.removeFromSuperview()
                    })
                })

            })
        }
    }
}
