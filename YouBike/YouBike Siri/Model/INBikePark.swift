//
//  INBikePark.swift
//  YouBike
//
//  Created by LAU KIM FAI on 24/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import Intents
import YouBikeKit

class INBikePark: INObject {
    convenience init(park: BikePark) {
        self.init(identifier: try? JSONEncoder().encode(park).utf8, display: park.ar)
    }
}

extension INObject {
    var bikePark: BikePark? {
        guard
            let data = identifier?.utf8,
            let park = try? JSONDecoder().decode(BikePark.self, from: data)
            else { return nil }
        return park
    }
}

extension Data {
    var utf8: String? { return String(data: self, encoding: .utf8) }
}

extension String {
    var utf8: Data? { return self.data(using: .utf8) }
}

extension CLLocationCoordinate2D {
    var location: CLLocation {
        return .init(latitude: latitude, longitude: longitude)
    }
}
