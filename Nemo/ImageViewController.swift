//
//  ImageViewController.swift
//  Nemo
//
//  Created by 박영호 on 2020/08/14.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var img: UIImage!
    var tag: Int! = 1
    var idxPath: IndexPath!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var anotherImageButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        imageView.image = img
//        imageView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
//        imageView.layer.borderWidth = 1.0
//        imageView.layer.cornerRadius = 5.0
//        ScrollView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
//        ScrollView.layer.borderWidth = 1.0
//        ScrollView.layer.cornerRadius = 5.0
        xButton.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        xButton.layer.borderWidth = 1.0
        xButton.layer.cornerRadius = 5.0
        xButton.layer.masksToBounds = true
        anotherImageButton.layer.borderColor = UIColor.systemBlue.cgColor
        anotherImageButton.layer.borderWidth = 1.0
        anotherImageButton.layer.cornerRadius = 5.0
        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func xButtonClick(_ sender: Any) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    let imagePicker = UIImagePickerController()
    @IBAction func anotherImageButtonClick(_ sender: Any) {
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
                DataManager.shared.imageList[idxPath.row] = img
            } else {
                DataManager.shared.imageList_2[idxPath.row] = img
            }
            
            //DataManager.shared.imageList.append(img)
//            self.CollectionView.reloadData()
//            CollectionViewHeight = CGFloat(((DataManager.shared.imageList.count + 2) / 3) * 110)
//            if CollectionViewHeight == 0 { CollectionViewHeight = 10 }
//            if CollectionViewHeight > 270.0 { CollectionViewHeight = 270.0}
//            CollectionViewHeightAnchor?.isActive = false
//            CollectionViewHeightAnchor = CollectionView.heightAnchor.constraint(equalToConstant: CollectionViewHeight)
//            CollectionViewHeightAnchor?.isActive = true
           
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
