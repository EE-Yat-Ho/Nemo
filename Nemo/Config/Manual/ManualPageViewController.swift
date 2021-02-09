//
//  ManualPageViewController.swift
//  Nemo
//
//  Created by 박영호 on 2021/01/03.
//  Copyright © 2021 Park young ho. All rights reserved.
//

import UIKit

class ManualPageViewController: UIViewController {

    var imageNames:[String] = ["backpack_note","memo_question","question","timer","incorrect"]
    var labelTexts:[String] = [
        "가방을 만들고,\n가방 안에 노트를 만들어 넣고,\n노트에 문제를 작성한 후 매일매일 풀어보세요!\n\n포함관계: 가방 ⊃ 노트 ⊃ (문제, 필기)",
        "처음 노트를 생성했을 때는 아무런 필기도 문제도 없어요. 우측 하단 버튼으로 생성해주실래요?",
        "여기서 생성한 문제들을 풀어볼 수 있어요!\n\"노트\" 혹은 \"생성시간\"별로 문제들을 선택하고, 원하는 문제 수를 입력하면, 입력한 수 만큼 랜덤으로 문제를 제출해줘요!",
        "여기서는 한 문제당 시간제한을 걸 수 있어요!\n시간이 경과되면 오답처리되고, 다음문제로 넘어가버려요..!",
        "여기는 오답노트에요! \"틀린 횟수\" 혹은 \"최근 틀린 시간\" 순으로 볼 수 있어요.\n여기서 삭제시, 해당 문제의 틀린 횟수와 틀린 시간이 초기화되요!"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPageViewController()
        setPageControl()
    }
        
    private func setPageViewController() {
        //  데이터소스와 델리게이트로 부모 뷰컨을 설정해줍니다
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        //  처음에 보여줄 컨텐츠 설정
        let firstVC = instantiateViewController(index: 0)
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        
        //  페이지 뷰컨을 부모 뷰컨에 띄워줍니다
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func setPageControl() {
        //  페이지 컨트롤에 전체 페이지 수를 설정해줍시다
        pageControl.numberOfPages = imageNames.count
        
        //  그리고 페이지 컨트롤을 화면에 띄워주면 됩니다
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    //  컨텐츠 뷰컨들이 올라갈 페이지 뷰컨이에요
    //  transitionStyle은 화면 전환 애니메이션
    //  navigationOrientation은 상하, 좌우 어디로 넘길건지
    private let pageViewController = UIPageViewController(transitionStyle: .pageCurl,
                                                          navigationOrientation: .horizontal)
    
    //  인디케이터로 사용할 페이지 컨트롤입니다
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .black   // 현재 페이지 인디케이터 색
        pc.pageIndicatorTintColor = .lightGray        // 나머지 페이지 인디케이터 색
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    //  컨텐츠 뷰컨을 만들어주는 메서드를 따로 만들어줬습니다
    private func instantiateViewController(index: Int) -> UIViewController {
        let vc = ManualViewController()
        vc.imageView.image = UIImage(named: imageNames[index])
        vc.manualLabel.text = labelTexts[index]
        vc.view.tag = index
        return vc
    }
}
extension ManualPageViewController: UIPageViewControllerDelegate {
    //  스와이프 제스쳐가 끝나면 호출되는 메서드입니다. 여기서 페이지 컨트롤의 인디케이터를 움직여줄꺼에요
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool
    ) {
        //  페이지 이동이 안됐으면 그냥 종료
        guard completed else { return }
        
        //  페이지 이동이 됐기 때문에 페이지 컨트롤의 인디케이터를 갱신해줍시다
        if let vc = pageViewController.viewControllers?.first {
            pageControl.currentPage = vc.view.tag
        }
    }
}
extension ManualPageViewController: UIPageViewControllerDataSource {
    //  이전 컨텐츠 뷰컨을 리턴해주시면 됩니다
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //  컨텐츠 뷰컨을 생성할 때 태그에 인덱스를 넣어줬기 때문에 몇번째 페이지인지 바로 알 수 있어요
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        
        // 이전 인덱스를 계산해주고요
        let nextIndex = index > 0 ? index - 1 : imageNames.count - 1
        
        // 이전 컨텐츠를 담은 뷰컨을 생성해서 리턴해줍니다
        let nextVC = instantiateViewController(index: nextIndex)
        return nextVC
    }
    
    //  다음 컨텐츠 뷰컨을 리턴해주시면 됩니다. 위에 메서드랑 똑같은데 다음 컨텐츠를 담으면 돼요
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        let nextIndex = (index + 1) % imageNames.count
        let nextVC = instantiateViewController(index: nextIndex)
        return nextVC
    }
}
