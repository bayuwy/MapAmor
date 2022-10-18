//
//  ShadowedView.swift
//  MapAmor
//
//  Created by Bayu Yasaputro on 18/10/22.
//

import UIKit

class ShadowedView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet { setup() }
    }
    
    weak var shadowLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            let shadowLayer = CAShapeLayer()
            layer.insertSublayer(shadowLayer, at: 0)
            self.shadowLayer = shadowLayer
        }
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        shadowLayer.fillColor = UIColor.systemBackground.cgColor
        shadowLayer.path = path.cgPath
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 10
    }
    
    func setup() {
        backgroundColor = .clear
    }
}
