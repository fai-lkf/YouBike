//
//  CoreX.swift
//  YouBike
//
//  Created by LAU KIM FAI on 7/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import Foundation
import Then

extension Double {
    func rounded(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Int {
    var d: Double { return .init(self) }
}

extension Date {
    var yyyy_MM_dd_HH_mm_ss: String { return "yyyy年MM月dd日 HH:mm:ss".df.string(from: self) }
}

extension String {
    var df: DateFormatter {
        return DateFormatter().then{
            $0.dateFormat = self
        }
    }
}
