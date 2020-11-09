//
//  TabPagerView.swift
//  UPlusAR
//
//  Created by baedy on 2020/03/24.
//  Copyright © 2020 최성욱. All rights reserved.
//

import NSObject_Rx
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

@objc public protocol TabPagerViewDelegate: AnyObject {
    @objc optional func willSelectButton(from fromIndex: Int, to toIndex: Int) -> Bool
    @objc optional func didSelectButton(at index: Int)
    @objc optional func willTransition(to index: Int)
    @objc optional func didTransition(to index: Int)
}

public protocol TabPagerViewDataSource: AnyObject {
    func numberOfItems() -> Int?
    func controller(at index: Int) -> UIViewController?
    func setCell(at index: Int) -> TabPagerHeaderCellModel?
    func separatViewColor() -> UIColor
    func defaultIndex() -> Int
    func shouldEnableSwipeable() -> Bool // default is true
    func wholeCellModel() -> [TabPagerHeaderCellModel]
}

@objc public protocol TabPagerViewDelegateLayout: AnyObject {
    // Header Setting

    /// default: 40
    @objc optional func heightForHeader() -> CGFloat
    /// default: 0
    @objc optional func leftOffsetForHeader() -> CGFloat
    /// default: 2
    @objc optional func heightForSeparation() -> CGFloat
    /// backgroundColor
    @objc optional func backgroundColor() -> UIColor
    /// equalHeaderCellWidth
    @objc optional func isStaticCellWidth() -> Bool // default is true

}

class TabPagerView: UIView {
    // MARK: delegate
    weak var delegate: TabPagerViewDelegate?
    weak var dataSource: TabPagerViewDataSource?
    weak var layoutDelegate: TabPagerViewDelegateLayout?

    var equleSpace = false

    // MARK: init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }

    init(isEquleSpace: Bool = false) {
        super.init(frame: .zero)
        self.equleSpace = isEquleSpace
        setupLayout()
        binding()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
        binding()
    }

    // MARK: view
//    private lazy var stackCollection = StackCollection().then {
//        $0.axis = .horizontal
//        $0.alignment = .leading
//        $0.distribution = .equalSpacing
//        $0.delegate = self
//    }

    private lazy var pagerHeader = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        if !equleSpace {
            $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }).then {
        $0.register(TabPagerHeaderCell.self, forCellWithReuseIdentifier: TabPagerHeaderCell.identifier)
        $0.backgroundColor = UIColor.black
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 6)
        $0.dataSource = self
        $0.delegate = self
    }

    let separateView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
    }

    private lazy var contentView = TabPagerContents().then {
        $0.onSelectionChanged = selectionChangeCloser
    }

    // MARK: Property
    lazy var selectionChangeCloser : ((_ index: Int) -> Void) = { index in
        self.current.accept(index)
    }

    private lazy var current = BehaviorRelay<Int?>(value: nil)

    private var defaultPageIndex: Int? {
        guard let _ = self.dataSource?.numberOfItems() else {
            return nil
        }
        guard let index = self.dataSource?.defaultIndex() else {
            return 0
        }
        return index
    }

    public weak var hostController: UIViewController?

    func setupLayout() {
        if !equleSpace {
            if let _ = pagerHeader.superview {
                pagerHeader.removeFromSuperview()
            }

            self.addSubview(pagerHeader)
            pagerHeader.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
            }
//        } else {
//            // add Stack
//            if let _ = stackCollection.superview {
//                stackCollection.removeFromSuperview()
//            }
//            self.addSubview(stackCollection)
//            stackCollection.snp.makeConstraints {
//                $0.top.equalToSuperview()
//                $0.leading.equalToSuperview().offset(-20)
//                $0.trailing.equalToSuperview().offset(20)
//            }
        }

        if let _ = separateView.superview {
            separateView.removeFromSuperview()
        }

        if let _ = contentView.superview {
            contentView.removeFromSuperview()
        }

        self.addSubview(separateView)
        separateView.snp.makeConstraints {
            $0.top.equalTo(pagerHeader.snp.bottom)//self.equleSpace ? stackCollection.snp.bottom : pagerHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        self.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(separateView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func binding() {
        self.current.compactMap { $0 }
            //.distinctUntilChanged()
            .subscribe(onNext: { [weak self] currentIndex in
                let interactionView = self?.pagerHeader//self?.equleSpace ?? false ? self?.stackCollection : self?.pagerHeader
                interactionView?.isUserInteractionEnabled = false
                self?.contentView.pageScroll(to: currentIndex) {
                    interactionView?.isUserInteractionEnabled = true
                }
        }).disposed(by: rx.disposeBag)

        let currentIndex = current
            .map { index in
                return IndexPath(item: index!, section: 0)
            }

        if !equleSpace {
            pagerHeader.rx.itemSelected
                .map { $0.item }
                .bind(to: current)
                .disposed(by: rx.disposeBag)

            currentIndex.subscribe(onNext: { [weak self] index in
                self?.pagerHeader.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
            }).disposed(by: rx.disposeBag)
        } else {
            // currentIndex bind stackSelection
//            currentIndex.subscribe(onNext: { [weak self] index in
//                self?.stackCollection.reloadData(at: index.item)
//            }).disposed(by: rx.disposeBag)
        }
    }

    func reload() {
        self.contentView.delegate = self.delegate
        self.contentView.dataSource = self.dataSource
        self.contentView.hostController = self.hostController

        if !equleSpace {
            self.pagerHeader.snp.remakeConstraints {
                $0.leading.equalToSuperview().offset(self.layoutDelegate?.leftOffsetForHeader?() ?? 0)
                $0.top.trailing.equalToSuperview()
                $0.height.equalTo(self.layoutDelegate?.heightForHeader?() ?? 56)
            }

            self.pagerHeader.reloadData()

            if let bgColor = self.layoutDelegate?.backgroundColor?() {
                self.contentView.backgroundColor = bgColor
                pagerHeader.backgroundColor = bgColor
            }
        } //else {
//            // stack reloadData
//
//            if let itemCount = dataSource?.numberOfItems(), itemCount == 1 {
//                self.stackCollection.snp.remakeConstraints {
////                    $0.leading.equalToSuperview().offset(20)
////                    $0.trailing.equalToSuperview().offset(-20)
//                    $0.leading.equalToSuperview().offset(20)
//                    $0.width.equalTo(63)
//                    $0.top.equalToSuperview()
//                    $0.height.equalTo(self.layoutDelegate?.heightForHeader?() ?? 56)
//                }
//            } else {
//                self.stackCollection.snp.remakeConstraints {
//                    $0.leading.equalToSuperview().offset(20)
//                    $0.trailing.equalToSuperview().offset(-20)
//                    $0.top.equalToSuperview()
//                    $0.height.equalTo(self.layoutDelegate?.heightForHeader?() ?? 56)
//                }
//            }
//            self.stackCollection.addArrangedSubviews(models: dataSource?.wholeCellModel() ?? [])
//            self.stackCollection.reloadInputViews()
//        }

        self.separateView.snp.makeConstraints {
            $0.height.equalTo(self.layoutDelegate?.heightForSeparation?() ?? 1)
        }

        self.contentView.reload(self.current.value ?? 0)
    }

    func didLoadsetupLayout(handler: (() -> Void)? = nil) {
        // separate view
        separateView.backgroundColor = self.dataSource?.separatViewColor() ?? .lightGray

        self.contentView.reload(current.value ?? 0)

        if (self.layoutDelegate?.isStaticCellWidth?() ?? false) && !equleSpace {
            updateFixedHeaderCelllayout(count: self.dataSource?.numberOfItems() ?? 0)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.changeIndex(self?.defaultPageIndex ?? 0)
            self?.layoutIfNeeded()
            handler?()
        })
    }

    func changeIndex(_ index: Int) {
        self.current.accept(index)
    }

    func updateFixedHeaderCelllayout(count: Int) {
        switch count {
        case 2, 3:
            let cellWidth = (UIScreen.main.bounds.width - 40) / CGFloat(count)
            pagerHeader.setCollectionViewLayout(UICollectionViewFlowLayout().then {
                $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                $0.scrollDirection = .horizontal
                $0.minimumLineSpacing = 0
                $0.minimumInteritemSpacing = 0
                $0.itemSize = CGSize(width: cellWidth, height: self.layoutDelegate?.heightForHeader?() ?? 56)
            }, animated: true)
        default: break
        }
    }

    func spacing() -> CGFloat {
        if let items = dataSource?.numberOfItems() {
            let cellsItemSize = (0..<items).map {
                dataSource?.setCell(at: $0)
            }.compactMap {
                guard var width = $0?.title.widthOfString(usingFont: TabPagerHeaderDefault.selectedFont) else { return nil }
                if width < 30 {
                    width = CGFloat(31)
                }
//                return ceil(width)
                return width
            }.reduce(CGFloat(0), +)

            return UIScreen.main.bounds.width - cellsItemSize - 40
        }

        return 0
    }
}

//extension TabPagerView: SCDelegate {
//    func stackCollection(_ sc: StackCollection, didSelectItemAt item: Int) {
//        current.accept(item)
//    }
//}
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TabPagerView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.numberOfItems() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabPagerHeaderCell.reuseIdentifier, for: indexPath) as? TabPagerHeaderCell, let data = self.dataSource?.setCell(at: indexPath.item) {
            cell.cellset(data)

            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.collectionViewLayout.invalidateLayout()

        self.current.accept(indexPath.item)
//
//        DispatchQueue.main.async {
//            collectionView.layoutIfNeeded()
//            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        }
    }
}
