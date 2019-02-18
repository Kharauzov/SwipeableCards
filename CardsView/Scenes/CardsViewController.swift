//
//
//  CardsView
//
//  Created by Serhii Kharauzov on 2/10/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import Foundation
import UIKit

class CardsViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cardsView: CardsView!
    @IBOutlet weak var bottomView: UIView!
    
    // MARK: Properties
    
    let storage = MockStorage.shared
    var displayData = [CardCellDisplayable]()
    lazy var cardImageViewHeight: CGFloat = cardsView.frame.height * 0.45 //  45% is cell.imageView height constraint's multiplier
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setCardsViewLayout()
        if let firstItem = storage.data.first {
            displayData.append(firstItem)
        }
        cardsView.reloadData()
        cardsView.scrollToItem(at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleViewControllerPresentation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        handleViewControllerDismiss()
    }
    
    // MARK: Methods
    
    func setCardsViewLayout() {
        view.layoutIfNeeded()
        cardsView.setLayout()
    }
    
    func handleViewControllerPresentation() {
        if displayData.count == storage.data.count { return }
        var indexPaths = [IndexPath]()
        for (index, _) in storage.data.enumerated() {
            if index != 0 {
                indexPaths.append(IndexPath(row: index, section: 0))
                displayData.append(storage.data[index])
            }
        }
        cardsView.insertItems(at: indexPaths)
    }
    
    func handleViewControllerDismiss() {
        let amountOfCells = cardsView.numberOfItems(inSection: 0)
        if amountOfCells == 0 { return }
        var indexPathesToDelete = [IndexPath]()
        for index in (1 ..< amountOfCells).reversed() {
            indexPathesToDelete.append(IndexPath(row: index, section: 0))
            displayData.remove(at: index)
        }
        cardsView.deleteItems(at: indexPathesToDelete)
    }
}

// MARK: StoryboardInitialisable Protocol

extension CardsViewController {
    static func instantiateViewController() -> CardsViewController {
        return Storyboard.main.viewController(CardsViewController.self)
    }
}

// MARK: CollectionView DataSource

extension CardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as! CardCollectionViewCell
        cell.setContent(data: displayData[indexPath.row])
        cell.delegate = self
        cell.actionsHandler = self
        return cell
    }
}

extension CardsViewController: SwipingCollectionViewCellDelegate {
    func cellSwipe(_ cell: SwipingCollectionViewCell, with progress: CGFloat) {
        bottomView.alpha = 1 - progress
        bottomView.transform.ty = progress * 50
    }
    
    func cellSwipedUp(_ cell: SwipingCollectionViewCell) {
        if let interactiveTransitionableViewController = presentingViewController as? InteractiveTransitionableViewController,
            let interactiveDismissTransition = interactiveTransitionableViewController.interactiveDismissTransition as? MiniToLargeViewInteractiveAnimator {
            interactiveDismissTransition.isEnabled = false
        }
    }
    
    func cellReturnedToInitialState(_ cell: SwipingCollectionViewCell) {
        if let interactiveTransitionableViewController = presentingViewController as? InteractiveTransitionableViewController,
            let interactiveDismissTransition = interactiveTransitionableViewController.interactiveDismissTransition as? MiniToLargeViewInteractiveAnimator {
            interactiveDismissTransition.isEnabled = true
        }
    }
}

extension CardsViewController: CardCollectionViewCellActionsHandler {
    func deleteButtonTapped(cell: CardCollectionViewCell) {
        if let index = cardsView.indexPath(for: cell)?.row {
            storage.data.remove(at: index)
            displayData.remove(at: index)
            cardsView.removeItem(at: index)
        }
        if displayData.isEmpty {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension CardsViewController: MiniToLargeAnimatable {
    var animatableBackgroundView: UIView {
        return backgroundView
    }
    
    var animatableMainView: UIView {
        return contentView
    }
    
    func prepareBeingDismissed() {
        cardsView.hideAllCellsExceptSelected(animated: true)
    }
}
