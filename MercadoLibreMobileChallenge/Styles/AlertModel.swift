//
//  AlertModel.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation
import SwiftUI

public struct AlertModel {
    public var title: String
    public var message: String?
    public var mainButtonTitle: String?
    public var secondButtonTitle: String?
    public var mainButtonAction: (() -> Void)?
    public var secondButtonAction: (() -> Void)?
    
    public init(title: String, message: String? = nil, mainButtonTitle: String? = nil, secondButtonTitle: String? = nil, mainButtonAction: (() -> Void)? = nil, secondButtonAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.mainButtonTitle = mainButtonTitle
        self.secondButtonTitle = secondButtonTitle
        self.mainButtonAction = mainButtonAction
        self.secondButtonAction = secondButtonAction
    }
    
    public init() {
        self.title = ""
        self.message = nil
        self.mainButtonTitle = ""
        self.secondButtonTitle = nil
        self.mainButtonAction = nil
        self.secondButtonAction = nil
    }
}

extension AlertModel {
    static func defaultAlert(mainButtonAction: (() -> Void)? = nil) -> AlertModel {
        AlertModel(title: "ERROR",
                   message: "Some error Appear",
                   mainButtonTitle: "got it",
                   mainButtonAction: mainButtonAction)
    }
}
