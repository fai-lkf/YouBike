//
//  CommonX.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import Foundation

protocol Namable {
    static var name: String { get }
}

extension Namable {
    static var name: String { return .init(describing: self) }
}
