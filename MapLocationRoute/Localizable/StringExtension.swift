//
//  AllStrings.swift
//  MapLocationRoute
//
//  Created by Konstantin Bolgar-Danchenko on 06.12.2022.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
