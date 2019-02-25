//
//  
//  CardsView
//
//  Created by Serhii Kharauzov on 2/10/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import UIKit

protocol CardCollectionViewCellActionsHandler: class {
    func deleteButtonTapped(cell: CardCollectionViewCell)
}

class CardCollectionViewCell: SwipingCollectionViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var action1Button: UIButton!
    @IBOutlet weak var action2Button: UIButton!
    @IBOutlet weak var action3Button: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: Properties
    
    weak var actionsHandler: CardCollectionViewCellActionsHandler?
    
    // MARK: Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSwipeDistanceValue(actionsView.bounds.height)
        frontContentView.layer.cornerRadius = 10.0
    }
    
    func setContent(data: CardCellDisplayable) {
        avatarImageView.image = UIImage(named: data.imageViewFileName)
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        detailsLabel.text = data.details
        qrCodeImageView.image = UIImage(named: data.qrCodeImageFileName)
    }
    
    override func frontViewPositionChanged(on percent: CGFloat) {
        super.frontViewPositionChanged(on: percent)
        action3Button.alpha = percent
        action2Button.alpha = percent
        action1Button.alpha = percent
        editButton.alpha = percent
        shareButton.alpha = percent
        deleteButton.alpha = percent
        
        let transformPercent = min(percent / 4 + 0.75, 1)
        action3Button.transform = CGAffineTransform(scaleX: transformPercent, y: transformPercent)
        action2Button.transform = CGAffineTransform(scaleX: transformPercent, y: transformPercent)
        action1Button.transform = CGAffineTransform(scaleX: transformPercent, y: transformPercent)
        editButton.transform = CGAffineTransform(scaleX: transformPercent, y: transformPercent)
        shareButton.transform = CGAffineTransform(scaleX: transformPercent, y: transformPercent)
        deleteButton.transform = CGAffineTransform(scaleX: transformPercent, y: transformPercent)
    }
    
    private func handleButtonTap(completion: @escaping () -> Void) {
        moveCellToInitialState {
            completion()
        }
    }
    
    // MARK: IBActions
    
    @IBAction private func action1ButtonTapped(_ sender: Any) {
        handleButtonTap {
            // todo
        }
    }
    
    @IBAction private func editButtonTapped(_ sender: Any) {
        handleButtonTap { 
            // todo
        }
    }
    
    @IBAction private func shareButtonTapped(_ sender: Any) {
        handleButtonTap { 
            // todo
        }
    }
    
    @IBAction private func deleteButtonTapped(_ sender: Any) {
        handleButtonTap { [weak self] in
            guard let self = self else { return }
            self.actionsHandler?.deleteButtonTapped(cell: self)
        }
    }
}
