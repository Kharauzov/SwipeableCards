//
//  MockStorage.swift
//  CardsView
//
//  Created by Serhii Kharauzov on 2/16/19.
//  Copyright © 2019 Serhii Kharauzov. All rights reserved.
//

import Foundation

class MockStorage {
    static let shared = MockStorage()
    let imageFileName = "james_bond"
    lazy var data = [
        CardCellDisplayable(imageViewFileName: imageFileName, title: "iOS Developer", subtitle: "Apple", details: "Animations/Transitions", qrCodeImageFileName: "qrcode"),
        CardCellDisplayable(imageViewFileName: imageFileName, title: "Android Developer", subtitle: "Google", details: "Location/Maps", qrCodeImageFileName: "qrcode"),
        CardCellDisplayable(imageViewFileName: imageFileName, title: "C++ Architect", subtitle: "Amazon", details: "Core", qrCodeImageFileName: "qrcode")
    ]
    
    private init() {}
}
