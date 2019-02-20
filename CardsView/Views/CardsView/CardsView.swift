//
//  CardsView.swift
//  CardsView
//
//  Created by Serhii Kharauzov on 2/13/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import UIKit

class CardsView: UICollectionView {

    // MARK: Properties
    
    private var currentPageIndex = 0
    private let cellLineSpaceValue: CGFloat = 18.0 // for space between cells
    private let cellLeadingConstant: CGFloat = 30.0 // for adding spaces to cell's width from left & right sides
    private var cellWidth: CGFloat = 0
    private var cellHeight: CGFloat = 0
    
    // MARK: Methods
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialise()
    }

    private func initialise() {
        register(UINib(nibName: CardCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        decelerationRate = UIScrollView.DecelerationRate.fast
        delegate = self
    }
    
    func setLayout() {
        cellWidth = frame.size.width - (2 * cellLeadingConstant)
        cellHeight = frame.size.height
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: cellLeadingConstant, bottom: 0, right: cellLeadingConstant)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = cellLineSpaceValue
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionViewLayout = layout
    }
    
    func scrollToItem(at index: Int) {
        if index > numberOfItems(inSection: 0) { return }
        scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
        currentPageIndex = index
    }
    
    func reloadItem(at index: Int) {
        if index > numberOfItems(inSection: 0) { return }
        reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func removeItem(at index: Int) {
        if index > numberOfItems(inSection: 0) { return }
        deleteItems(at: [IndexPath(row: index, section: 0)])
        currentPageIndex = getVisibleCardIndexPath()?.row ?? 0
    }
    
    func getVisibleCardIndexPath() -> IndexPath? {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return indexPathForItem(at: visiblePoint)
    }
    
    func hideAllCellsExceptSelected(animated: Bool) {
        for index in 0 ..< numberOfItems(inSection: 0) {
            if index != currentPageIndex {
                cellForItem(at: IndexPath(row: index, section: 0))?.hide(animated: animated)
            }
        }
    }
    
    func showAllCells(animated: Bool) {
        for index in 0 ..< numberOfItems(inSection: 0) {
            cellForItem(at: IndexPath(row: index, section: 0))?.show(animated: animated)
        }
    }
}

extension CardsView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let pageWidth = Float(cellWidth + cellLineSpaceValue)
        currentPageIndex = Int(floor((Float(contentOffset.x) - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Float(cellWidth + cellLineSpaceValue)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(contentSize.width)
        var newPage = Float(currentPageIndex)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? currentPageIndex + 1 : currentPageIndex - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        currentPageIndex = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}
