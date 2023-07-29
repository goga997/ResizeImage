//
//  UIColor+Extension.swift
//  DiTatiCuVladu
//
//  Created by Grigore on 03.07.2023.
//

import Foundation
import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
