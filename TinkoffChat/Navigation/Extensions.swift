//
//  NavigationExtensions.swift
//  TinkoffChat
//
//  Created by s.zorin on 21.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit
import Foundation

extension UINavigationController {
    func navigate(to storyboardControllerID: StoryboardControllerID) {
        let id = storyboardControllerID.rawValue
        if let controller = storyboard?.instantiateViewController(withIdentifier: id) {
            pushViewController(controller, animated: true)
        }
    }
    
    func navigateBack() {
        popViewController(animated: true)
    }
}
