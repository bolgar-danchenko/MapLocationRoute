//
//  AdaptableSizeButton.swift
//  MapLocationRoute
//
//  Created by Konstantin Bolgar-Danchenko on 06.12.2022.
//

import Foundation
import UIKit

class AdaptableSizeButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        let desiredButtonSize = CGSize(width: labelSize.width + 20, height: labelSize.height + 10)
        
        return desiredButtonSize
    }
}
