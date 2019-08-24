//
//  StringError.swift
//  YouBikeKit
//
//  Created by LAU KIM FAI on 24/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import Foundation

public struct StringError {
    let message: String
}

extension StringError: LocalizedError {
    public var errorDescription: String? { return message }
}

extension String {
    public var error: StringError { return .init(message: self) }
}
