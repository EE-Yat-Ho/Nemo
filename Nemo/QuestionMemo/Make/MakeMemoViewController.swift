//
//  MakeMemoViewController.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/07/12.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class MakeMemoViewController: UIViewController {
    var editTarget: Memo?
    
    var containerView = UIView()
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    var memoLabel = UILabel().then{
        $0.text = "메모 내용"
    }
    var cameraButton = UIButton().then{
        $0.setImage(UIImage(named: "이미지"), for: .normal)
        $0.addTarget(self, action: #selector(addImageToQuestion), for: .touchUpInside)
    }
    var memoContent = UITextView().then{
        $0.tag = 1
        $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.becomeFirstResponder()
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = UIColor.clear
    }
    
    let collectionItemSize: CGFloat = (UIScreen.main.bounds.size.width - 40) / 3
    lazy var collectionView = UICollectionView(
        frame: CGRect(x: 0, y: 0, width: 0, height: 0),
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: collectionItemSize, height: collectionItemSize)
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0}
        ).then{
            $0.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 5.0
            $0.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
            $0.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        }
    var collectionViewHeight: CGFloat = 10.0
    
    let touchesBeganButton = UIButton().then {
        $0.setImage(nil, for: .normal)
        $0.addTarget(self, action: #selector(keyBoardDown), for: .touchUpInside)
    }
    @objc func keyBoardDown() {
        self.view.endEditing(true)
    }
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        memoContent.delegate = self
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: nil,
                            action: #selector(save(_:)))
        
        setupLayout()
        dataLoad()
    }
    
    @objc func KeyBoardwillShow(_ noti : Notification ){
        let keyboardHeight = ((noti.userInfo as! NSDictionary).value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.height
        scrollView.snp.updateConstraints{
            $0.bottom.equalToSuperview().offset(-keyboardHeight)
        }
    }
    @objc func KeyBoardwillHide(_ noti : Notification ){
        scrollView.snp.updateConstraints{
            $0.bottom.equalToSuperview()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func setupLayout() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardwillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                       
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(memoLabel)
        contentView.addSubview(cameraButton)
        contentView.addSubview(memoContent)
        contentView.addSubview(collectionView)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "배경")!)
        
        scrollView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.leading.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints{
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width) }
        
        memoLabel.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        cameraButton.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).inset(20)
            $0.leading.equalTo(memoLabel.snp.trailing).offset(10)
            $0.height.width.equalTo(20)
        }
        memoContent.snp.makeConstraints{
            $0.top.equalTo(memoLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(270)
        }
        collectionView.snp.makeConstraints{
            $0.top.equalTo(memoContent.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(10)
        }
        
        /// ㅋㅋㅋㅋ 키보드 내리는거 결국 이캐하네 2
        contentView.addSubview(touchesBeganButton)
        touchesBeganButton.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        contentView.sendSubviewToBack(touchesBeganButton)
        /// 굳
    }
    
    func dataLoad() {
        guard let editTarget = editTarget else {return}
        
        memoContent.text = editTarget.content
        
        DataManager.shared.imageList.removeAll()
        for i in editTarget.images ?? [Data]() {
            DataManager.shared.imageList.append(UIImage(data: i)!)
        }
        collectionViewHeight = collectionItemSize * CGFloat((DataManager.shared.imageList.count + 2) / 3)
        if collectionViewHeight == 0.0 { collectionViewHeight = 10.0 }
        if collectionViewHeight > collectionItemSize * 2.5 { collectionViewHeight = collectionItemSize * 2.5}
        collectionView.snp.updateConstraints{
            $0.height.equalTo(collectionViewHeight)
        }
    }
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func save(_ sender: Any) {
        //메모 갈아거 0이면 메모 입력하세요 띄우기
        if memoContent.text.count == 0 || memoContent.text == "메모 내용 입력" {
           alert(message: "메모 내용을 입력하세요.")
           return
        }

        if editTarget == nil {
            DataManager.shared.addNewMemo(content: memoContent.text)
            
        } else {
            editTarget?.content = memoContent.text
            editTarget?.images = DataManager.shared.imageList.map{$0.jpegData(compressionQuality: 0.01)!}
            DataManager.shared.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension MakeMemoViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    //20200720 사진을 고르는 화면 구현
    @objc func addImageToQuestion() {
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
            DataManager.shared.imageList.append(img)
            self.collectionView.reloadData()
            collectionViewHeight = collectionItemSize * CGFloat((DataManager.shared.imageList.count + 2) / 3)
            if collectionViewHeight == 0 { collectionViewHeight = 10 }
            if collectionViewHeight > 270 { collectionViewHeight = 270 }
            collectionView.snp.updateConstraints{
                $0.height.equalTo(collectionViewHeight)
            }
            collectionView.reloadData()
        }
    }
}

extension MakeMemoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 20200720 올린 사진을 보여줄 콜랙션뷰 구현
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.imageList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.delegate = self
        cell.mappingData(index: indexPath.row, tag: 1)
//        cell.index = indexPath.row
//        cell.imageView.image = DataManager.shared.imageList[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let imageViewController = ImageViewController()
        imageViewController.imageView.image = DataManager.shared.imageList[indexPath.row]

        imageViewController.tag = 1
        imageViewController.index = indexPath.row
        navigationController?.pushViewController(imageViewController, animated: true)
    }
}


extension MakeMemoViewController: UITextViewDelegate {
    // 텍스트뷰가 편집되기 시작하면
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메모 내용 입력" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "메모 내용 입력"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
}

extension MakeMemoViewController: CollectionDelegate {
    func clickXButton(_ cell: CollectionViewCell) {
        DataManager.shared.imageList.remove(at: cell.index)
        
        collectionViewHeight = collectionItemSize * CGFloat((DataManager.shared.imageList.count + 2) / 3)
        if collectionViewHeight == 0 { collectionViewHeight = 10 }
        if collectionViewHeight > 270 { collectionViewHeight = 270 }
        collectionView.snp.updateConstraints{
            $0.height.equalTo(collectionViewHeight)
        }
        collectionView.reloadData()
    }
}
