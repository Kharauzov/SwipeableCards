//
//  
//  CardsView
//
//  Created by Serhii Kharauzov on 2/10/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import UIKit

protocol CardCollectionViewCellDelegate: class {
    /// 'percent' is a CGFloat value from 0 to 1.
    func frontViewPositionChanged(_ cell: CardCollectionViewCell, on percent: CGFloat)
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
    
    // MARK: Public properties
    
    weak var actionResponder: CardCollectionViewCellDelegate?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        swipeDistanceOnY = actionsView.bounds.height
        backContentView.layer.cornerRadius = 10.0
        frontContentView.layer.cornerRadius = 10.0
        clipsToBounds = false
    }
    
    override func prepareForReuse() {
        frontContentView.center = backContentView.center // setting default position of cell's frontContentView when cell is reused
    }
    
    // MARK: Methods
    
    func setContent(data: CardCellDisplayable) {
        avatarImageView.image = UIImage(named: data.imageViewFileName)
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        detailsLabel.text = data.details
        qrCodeImageView.image = UIImage(named: data.qrCodeImageFileName)
    }
    
    override func frontViewPositionChanged(on percent: CGFloat) {
        actionResponder?.frontViewPositionChanged(self, on: percent)
        
        action3Button.alpha = percent
        action2Button.alpha = percent
        action1Button.alpha = percent
        editButton.alpha = percent
        shareButton.alpha = percent
        deleteButton.alpha = percent
        
        var fixedPercent = percent / 4 + 0.75
        if fixedPercent > 1 {
            fixedPercent = 1
        }
        action3Button.transform = CGAffineTransform(scaleX: fixedPercent, y: fixedPercent)
        action2Button.transform = CGAffineTransform(scaleX: fixedPercent, y: fixedPercent)
        action1Button.transform = CGAffineTransform(scaleX: fixedPercent, y: fixedPercent)
        editButton.transform = CGAffineTransform(scaleX: fixedPercent, y: fixedPercent)
        shareButton.transform = CGAffineTransform(scaleX: fixedPercent, y: fixedPercent)
        deleteButton.transform = CGAffineTransform(scaleX: fixedPercent, y: fixedPercent)
    }
    
    private func handleButtonTap(completion: @escaping () -> Void) {
        moveCellToInitialState {
            completion()
        }
    }
    
    // MARK: IBActions
    
    @IBAction private func action1ButtonTapped(_ sender: Any) {
        handleButtonTap {
            //self.actionResponder?.recieveReviewsButtonTapped(cell: self)
        }
    }
    
    @IBAction private func editButtonTapped(_ sender: Any) {
        handleButtonTap { 
            //self.actionResponder?.editButtonTapped(cell: self)
        }
    }
    
    @IBAction private func shareButtonTapped(_ sender: Any) {
        handleButtonTap { 
            //self.actionResponder?.shareButtonTapped(cell: self)
        }
    }
    
    @IBAction private func deleteButtonTapped(_ sender: Any) {
        handleButtonTap { [weak self] in
            guard let self = self else { return }
            self.actionResponder?.deleteButtonTapped(cell: self)
        }
    }
}




