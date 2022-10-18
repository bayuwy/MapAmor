//
//  SecondaryButton.swift
//  MapAmor
//
//  Created by Bayu Yasaputro on 14/10/22.
//

import UIKit

@IBDesignable
class SecondaryButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet { update() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        update()
    }
    
    func update() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        backgroundColor = UIColor.secondarySystemFill
        tintColor = UIColor(
            named: "AccentColor",
            in: Bundle(for: self.classForCoder),
            compatibleWith: nil
        )
        
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
}
