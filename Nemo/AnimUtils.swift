//
//  AnimUtils.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/07/17.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class AnimUtils: NSObject, UITabBarControllerDelegate {
    // 뭐 탭바 컨트롤러에 애니메이션을 넘겨주는거 같은데..
    // 일단 쩌 아래에 구현한 서브 클래스 애니메이션을 여기서 리턴하면 그 애니메이션이 적용되는거임
    
    // 델리게이트 공부 후 : 탭바컨트롤러의 뷰 전환 애니메이션 부분을 대신해주는 클래스를 선언한거임! 그리고 그 함수를 오버라이딩 한거임!! 그 함수에서는 애니메이션 객체를 받음!!!
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScrollingAnim(tabBarController: tabBarController)
    }
}


class ScrollingAnim: NSObject, UIViewControllerAnimatedTransitioning{
    weak var transitionContext: UIViewControllerContextTransitioning?
    var tabBarController: UITabBarController!
    var fromIndex = 0
    
    init(tabBarController: UITabBarController){
        self.tabBarController = tabBarController
        self.fromIndex = tabBarController.selectedIndex
    }
    
    // UIVCAT 를 상속하기위해 생성된 함수 1
    // 애니메이션 시간
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // UIVCAT 를 상속하기위해 생성된 함수 2
    // 애니메이션 .. 뭐지 이 함수는? 애니메이션 효과를 정의하는 함수!
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 뷰 만들어주기
        // 매개변수로 들어온
        self.transitionContext = transitionContext
        let containerView = transitionContext.containerView
        
        // 원래 뷰
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        // 추가될 뷰
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        containerView.addSubview(toView!.view)
        
        var width = toView?.view.bounds.width
        
        // 현재 포지션과 새로들어온 포지션 비교 (왼쪽으로? 오른쪽으로? 어디로 갈지 정하는겅)
        // fromIndex : 기존 값
        // tabBarController.selectedIndex : 새로 들어온 값
        if tabBarController.selectedIndex < fromIndex{
            width = -width!
        }
        
        toView!.view.transform = CGAffineTransform(translationX: width!, y: 0)
        
        UIView.animate(withDuration: self.transitionDuration(using: self.transitionContext), animations: {
            // 입력되는 뷰
            toView?.view.transform = CGAffineTransform.identity
            fromView?.view.transform = CGAffineTransform(translationX: -width!, y: 0)
        }, completion: { _ in // 뭐냐 이 in은
            fromView?.view.transform = CGAffineTransform.identity
            self.transitionContext?.completeTransition(!(self.transitionContext?.transitionWasCancelled)!)
        })
    }
    
}
