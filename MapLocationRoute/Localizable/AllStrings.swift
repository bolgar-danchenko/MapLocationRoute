//
//  AllStrings.swift
//  MapLocationRoute
//
//  Created by Konstantin Bolgar-Danchenko on 06.12.2022.
//

import Foundation

final class AllStrings {
    
    static let shared = AllStrings()
    
    let createRouteButtonTittle = NSLocalizedString("createRoute", comment: "Create Route button")
    let removeRouteButtonTittle = NSLocalizedString("removeRoute", comment: "Remove Route button")
    let locationDeniedDescr = NSLocalizedString("locationDenied", comment: "Label on the main screen if access is denied")
    let errorAlertTitle = NSLocalizedString("attention", comment: "Error alert title")
    let okButtonLabel = NSLocalizedString("ok", comment: "OK alert action")
    let locationErrorDescr = NSLocalizedString("locationErrorDescr", comment: "Location error alert description")
    let addPinTitle = NSLocalizedString("addPin", comment: "Add pin alert title")
    let addPinDescr = NSLocalizedString("enterTitle", comment: "Add pin alert message")
    let addPinPlaceholder = NSLocalizedString("addPinPlaceholder", comment: "Add pin alert placeholder")
    let cancelButtonLabel = NSLocalizedString("cancel", comment: "Cancel alert action")
    let pinAddingErrorDescr = NSLocalizedString("unableToAddAnnotation", comment: "Error while adding annotation description")
    let routeUnavailableDescr = NSLocalizedString("routeUnavailable", comment: "Route unavailable alert description")
    let routeAlertTitle = NSLocalizedString("whereToGo", comment: "Create route alert title")
    let routeAlertPlaceholder = NSLocalizedString("cityOrLocation", comment: "Create route alert placeholder")
    let routeAlertOkButton = NSLocalizedString("letsGo", comment: "Create route alert ok action")
    let emptyLocationText = NSLocalizedString("addressCantBeAmpty", comment: "Error message when textfield is empty")
    
    let florenceTitle = NSLocalizedString("florence", comment: "Florence city name")
    let florenceInfo = NSLocalizedString("leapOfFaith", comment: "Florence city info")
    let romeTitle = NSLocalizedString("rome", comment: "Rome city name")
    let romeInfo = NSLocalizedString("goodPasta", comment: "Rome city info")
    let berlinTitle = NSLocalizedString("berlin", comment: "Berlin city name")
    let berlinInfo = NSLocalizedString("ichBinEinBerliner", comment: "Berlin city info")
    let luxembourgTitle = NSLocalizedString("luxembourg", comment: "Luxembourg city name")
    let luxembourgInfo = NSLocalizedString("veryNiceCity", comment: "Luxembourg city info")
    let zurichTitle = NSLocalizedString("zurich", comment: "Zurich city name")
    let zurichInfo = NSLocalizedString("flamingosWalkingAround", comment: "Zurich city info")
    
    let loadingIndicatorLabel = NSLocalizedString("pleaseWait", comment: "Loading indicator label")
}
