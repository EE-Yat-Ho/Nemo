//
//  ImageViewController.swift
//  Nemo
//
//  Created by 박영호 on 2020/08/14.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var tag = -1
    var index = -1
    let imageView = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    let scrollView = UIScrollView()
    var leftButton = UIButton().then{
        $0.setImage(UIImage(named:"편집_뒤로가기"), for: .normal)
        $0.addTarget(self, action: #selector(clickLeftButton), for: .touchUpInside)
    }
    var anotherImageButton = UIButton().then{
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.addTarget(self, action: #selector(clickAnotherImageButton), for: .touchUpInside)
        $0.setTitle("다른 이미지 선택", for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setupLayout()
    }
    
    func setupLayout() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(leftButton)
        view.addSubview(scrollView)
        view.addSubview(anotherImageButton)
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
            $0.centerY.equalToSuperview().offset(-30)
            $0.height.width.equalTo(30)
        }
        
        anotherImageButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(60)
            $0.height.equalTo(40)
        }
        view.sendSubviewToBack(imageView)
    }
    
    @objc func clickLeftButton() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    let imagePicker = UIImagePickerController()
    @objc func clickAnotherImageButton() {
        self.openImagePicker()
    }
    func openImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :Any]){
        dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage{
            imageView.image = img
            if tag == 1 {
                DataManager.shared.imageList_MC[index] = img
            } else {
                DataManager.shared.imageList_MC_2[index] = img
            }
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
