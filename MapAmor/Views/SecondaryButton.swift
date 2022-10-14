//
//  SecondaryButton.swift
//  MapAmor
//
//  Created by Bayu Yasaputro on 14/10/22.
//

import UIKit

@IBDesignable
class SecondaryButton: PrimaryButton {
    override func update() {
        super.update()
        backgroundColor = UIColor.secondarySystemFill
        tintColor = UIColor(
            named: "AccentColor",
            in: Bundle(for: self.classForCoder),
            compatibleWith: nil
        )
    }
}
