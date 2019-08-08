//
//  LocationResponse.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import Foundation

struct FakeResponse: Codable {
    let abc: String
}

struct BikeParkResponse: Codable {
    let retCode: Int
    let retVal: [String: BikePark]
}

struct BikePark: Codable {
    let sno: String // 0004
    let sna: String // 市民廣場
    let tot: String // 60
    let sbi: String // 27
    let sarea: String // 信義區
    let mday: String // 20190806223730
    let lat: String // 25.0360361111
    let lng: String // 121.562325
    let ar: String // 市府路/松壽路(西北側)(鄰近台北101/台北世界貿易中心/台北探索館)
    let sareaen: String // Xinyi Dist.
    let snaen: String // Citizen Square
    let aren: String // The N.W. side of Road Shifu & Road Song Shou.
    let bemp: String // 31
    let act: String // 1
    let lastFetch = Date()
}

extension BikePark {
    var disabled: Bool { return act == "0" }
    var occupancy: Int { return Int(sbi) ?? 0 }
    var availability: Int { return Int(bemp) ?? 0 }
    var total: Int { return occupancy + availability }
}
