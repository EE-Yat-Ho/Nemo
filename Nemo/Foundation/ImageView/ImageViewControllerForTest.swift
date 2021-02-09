//
//  ImageViewController.swift
//  Nemo
//
//  Created by 박영호 on 2020/08/14.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class ImageViewControllerForTest: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let imageView = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    let scrollView = UIScrollView().then{
        $0.minimumZoomScale = 1.0
        $0.maximumZoomScale = 4.0
    }
    var leftButton = UIButton().then{
        $0.setImage(UIImage(named:"x_gray"), for: .normal)
        //$0.addTarget(self, action: #selector(clickLeftButton), for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    func setupLayout() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        navigationController?.navigationBar.isHidden = true
        view.addSubview(leftButton)
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints{
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.width.equalTo(30)
        }
        imageView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
            $0.edges.equalToSuperview()
        }
        view.sendSubviewToBack(scrollView)
    }
    
//    @objc func clickLeftButton() {
        //dismiss(animated: true, completion: nil)
   // }
}

extension ImageViewControllerForTest: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
