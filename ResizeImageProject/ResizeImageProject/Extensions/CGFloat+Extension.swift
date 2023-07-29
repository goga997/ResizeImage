//
//  CGFloat + Extension.swift
//  DiTatiCuVladu
//
//  Created by Grigore on 03.07.2023.
//

import Foundation

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
