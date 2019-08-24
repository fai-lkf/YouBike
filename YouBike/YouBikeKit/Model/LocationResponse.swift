//
//  LocationResponse.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import Foundation
import MapKit
import Then

public struct BikeParkResponse: Codable {
    public let retCode: Int
    public let retVal: [String: BikePark]
}

public struct BikePark: Codable {
    public let sno: String // 0004
    public let sna: String // 市民廣場
    public let tot: String // 60
    public let sbi: String // 27
    public let sarea: String // 信義區
    public let mday: String // 20190806223730
    public let lat: String // 25.0360361111
    public let lng: String // 121.562325
    public let ar: String // 市府路/松壽路(西北側)(鄰近台北101/台北世界貿易中心/台北探索館)
    public let sareaen: String // Xinyi Dist.
    public let snaen: String // Citizen Square
    public let aren: String // The N.W. side of Road Shifu & Road Song Shou.
    public let bemp: String // 31
    public let act: String // 1
}

extension BikePark {
    public var disabled: Bool { return act == "0" }
    public var occupancy: Int { return Int(sbi) ?? 0 }
    public var availability: Int { return Int(bemp) ?? 0 }
    public var total: Int { return occupancy + availability }
    
    public var coordiante: CLLocationCoordinate2D? {
        guard
            let lat = Double(lat.trimmingCharacters(in: .whitespacesAndNewlines)),
            let lng = Double(lng.trimmingCharacters(in: .whitespacesAndNewlines))
            else { return nil }
        return .init(latitude: lat, longitude: lng)
    }
    
    public var annotation: MKPointAnnotation {
        return MKPointAnnotation().then{
            $0.title = ar
            $0.subtitle = sna
            if let origin = coordiante {
                $0.coordinate = origin
            }
        }
    }
    
    public var camera: MKMapCamera? {
        guard let origin = coordiante else { return nil }
        return .init(lookingAtCenter: origin, fromEyeCoordinate: origin, eyeAltitude: 400)
    }
    
    public var error: Error {
        return ["\(sna) 沒有提供經緯度", "地址為：\(ar)"].joined(separator: "\n").error
    }
}

extension MKAnnotation {
    public var bikePark: MKAnnotationView {
        return MKAnnotationView(annotation: self, reuseIdentifier: "BIKEPARK").then{
            $0.image = UIImage(named: "bike-parking")
            $0.canShowCallout = true
        }
    }
}
