//
//  PlaceViewCell.swift
//  MapAmor
//
//  Created by Bayu Yasaputro on 14/10/22.
//

import UIKit

protocol PlaceViewCellDelegate: NSObjectProtocol {
    func placeViewCellLearnButtonTapped(_ cell: PlaceViewCell)
    func placeViewCellNextButtonTapped(_ cell: PlaceViewCell)
}

class PlaceViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var learnButton: PrimaryButton!
    @IBOutlet weak var nextButton: SecondaryButton!

    weak var delegate: PlaceViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        learnButton.addTarget(self, action: #selector(self.learnButtonTapped(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(self.nextButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func learnButtonTapped(_ sender: Any) {
        delegate?.placeViewCellLearnButtonTapped(self)
    }
    
    @objc func nextButtonTapped(_ sender: Any) {
        delegate?.placeViewCellNextButtonTapped(self)
    }
}
