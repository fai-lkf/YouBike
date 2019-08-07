//
//  Key.swift
//  YouBike
//
//  Created by LAU KIM FAI on 7/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

enum UDKey: String {
    case bookmark
}

extension UDKey {
    var key: String { return "USER_DEFAULTS_\(rawValue)".uppercased() }
}
