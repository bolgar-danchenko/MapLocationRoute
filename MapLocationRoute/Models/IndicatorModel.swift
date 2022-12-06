//
//  IndicatorModel.swift
//  MapLocationRoute
//
//  Created by Konstantin Bolgar-Danchenko on 03.12.2022.
//

import Foundation
import JGProgressHUD

class IndicatorModel {
    
    static let loadingIndicator: JGProgressHUD = {
        let indicator = JGProgressHUD()
        indicator.textLabel.text = AllStrings.shared.loadingIndicatorLabel
        return indicator
    }()

}
