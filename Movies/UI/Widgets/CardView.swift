//
//  CardView.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import UIKit

class CardView: UIView {

    @IBInspectable public var topStartRadius: Bool = false {
        didSet { updateCorners() }
    }
    
    @IBInspectable public var topEndRadius: Bool = false {
        didSet { updateCorners() }
    }
    
    @IBInspectable public var bottomStartRadius: Bool = false {
        didSet { updateCorners() }
    }
    
    @IBInspectable public var bottomEndRadius: Bool = false {
        didSet { updateCorners() }
    }
    
    @IBInspectable public var cornerRadiusRadius: CGFloat = 0 {
        didSet { updateCorners() }
    }

    func updateCorners() {
        var corners = CACornerMask()
        
        if topStartRadius {
            corners.formUnion(.layerMinXMinYCorner)
        }
        if topEndRadius {
            corners.formUnion(.layerMaxXMinYCorner)
        }
        if bottomStartRadius {
            corners.formUnion(.layerMinXMaxYCorner)
        }
        if bottomEndRadius {
            corners.formUnion(.layerMaxXMaxYCorner)
        }

        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadiusRadius
    }
}
