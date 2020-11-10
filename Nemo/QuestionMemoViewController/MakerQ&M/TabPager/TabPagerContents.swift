////
////  TabPagerContents.swift
////  UPlusAR
////
////  Created by baedy on 2020/03/24.
////  Copyright © 2020 최성욱. All rights reserved.
////
//
//import RxCocoa
//import RxSwift
//import SnapKit
//import Then
//import UIKit
//
//class TabPagerContents: UIView {
//    private let disposeBag = DisposeBag()
//
//    //    func bindView(_ currentIndex: Observable<Int>) {
//    //        currentIndex.distinctUntilChanged().subscribe(onNext: self.pageScroll(to:)).disposed(by: disposeBag)
//    //    }
//
//    weak var hostController: UIViewController?
//
//    weak var delegate: TabPagerViewDelegate?
//    weak var dataSource: TabPagerViewDataSource?
//
//    var onSelectionChanged: ((_ selectedIndex: Int) -> Void)?
//
//    lazy var pageViewController: UIPageViewController? = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil).then {
//        $0.delegate = self
//        $0.dataSource = self
//    }
//
//    var shouldEnableSwipeable: Bool {
//        if let e = self.dataSource?.shouldEnableSwipeable() {
//            return e
//        } else {
//            return true
//        }
//    }
//}
//
//// MARK: UIPageViewControllerDelegate
//extension TabPagerContents: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
//    // page viewController인데 페이징을 못해요.. UID 페이징 제거 요청으로 인해 페이징 주석
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        nil
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        nil
//    }
//}
//
//extension TabPagerContents {
//    func pageScroll(to index: Int, completeHandler: (() -> Void)? = nil) {
//        let animated: Bool = true
//        pageViewController?.isScrollEnabled = false
//
//        let handler: () -> Void = {[weak self] in
//            self?.pageViewController?.isScrollEnabled = true
//            completeHandler?()
//        }
//
//        self.delegate?.willSelectButton?(from: self.pageViewController?.viewControllers?.get(0)?.index ?? 0, to: index)
//
//        if let controller = self.dataSource?.controller(at: index) {
//            controller.view.subviews.forEach {
//                $0.isUserInteractionEnabled = false
//            }
//
//            controller.index = index
//            if let currentIndex = self.pageViewController?.viewControllers?.get(0)?.index {
//                if true {
//                    if index == currentIndex {
//                        handler()
//                        controller.view.subviews.forEach {
//                            $0.isUserInteractionEnabled = true
//                        }
//                        return
//                    } else if index > currentIndex {
//                        self.pageViewController?.setViewControllers([controller], direction: .forward, animated: animated, completion: { _ in
//                            handler()
//                            controller.view.subviews.forEach {
//                                $0.isUserInteractionEnabled = true
//                            }
//                        })
//                    } else {
//                        self.pageViewController?.setViewControllers([controller], direction: .reverse, animated: animated, completion: { _ in
//                            handler()
//                            controller.view.subviews.forEach {
//                                $0.isUserInteractionEnabled = true
//                            }
//                        })
//                    }
//                    self.delegate?.didSelectButton?(at: index)
//                }
//            } else {
//                self.pageViewController?.setViewControllers([controller], direction: .forward, animated: animated, completion: { _ in
//                    handler()
//                    controller.view.subviews.forEach {
//                        $0.isUserInteractionEnabled = true
//                    }
//                })
//            }
//        }
//    }
//
//    public func reload(_ index: Int) {
//        guard let _ = hostController else { return }
//
//        if let pvc = self.pageViewController {
//            if let _ = pvc.view.superview {
//                pvc.willMove(toParent: nil)
//                pvc.view.removeFromSuperview()
//                pvc.didMove(toParent: nil)
//                pvc.removeFromParent()
//            }
//
//            hostController?.addChild(pvc)
//            pvc.willMove(toParent: hostController)
//            self.addSubview(pvc.view)
//            pvc.didMove(toParent: hostController)
//            pvc.isScrollEnabled = self.shouldEnableSwipeable
//        }
//
//        if let first = self.dataSource?.controller(at: index) {
//            self.pageViewController?.setViewControllers([first], direction: .forward, animated: false, completion: nil)
//            first.index = index
//        }
//        for view in self.pageViewController?.view.subviews ?? [] {
//            if view.isKind(of: UIScrollView.self) {
//                (view as! UIScrollView).delaysContentTouches = false
//                (view as! UIScrollView).canCancelContentTouches = true
//            }
//        }
//        self.pageViewController?.view.snp.makeConstraints({ make in
//            make.edges.equalToSuperview()
//        })
//    }
//}
//
//
//extension UIPageViewController {
//    var isScrollEnabled: Bool {
//        get {
//            var isEnabled: Bool = true
//            for view in view.subviews {
//                if let subView = view as? UIScrollView {
//                    isEnabled = subView.isScrollEnabled
//                }
//            }
//            return isEnabled
//        }
//        set {
//            for view in view.subviews {
//                if let subView = view as? UIScrollView {
//                    subView.isScrollEnabled = newValue
//                }
//            }
//        }
//    }
//}
//
//extension UIViewController {
//    private struct RuntimeKey {
//        static let indexKey = UnsafeRawPointer(bitPattern: "indexKey".hashValue)
//    }
//
//    public var index: Int {
//        set {
//            objc_setAssociatedObject(self, RuntimeKey.indexKey!, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//
//        get {
//            return  (objc_getAssociatedObject(self, RuntimeKey.indexKey!) as! NSNumber).intValue
//        }
//    }
//}
//
//extension Array {
//    func get(_ index: Int) -> Element? {
//        if 0 <= index && index < count {
//            return self[index]
//        } else {
//            return nil
//        }
//    }
//}
