//
//  BikeLocationAPI.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import Moya

enum BikeLocationAPI {
    case list
}

extension BikeLocationAPI: TargetType {
    
    var path: String {
        switch self {
        case .list:
            return "/YouBikeTP.json"
        }
    }
    
    var method: Method {
        switch self {
        case .list:
            return .get
        }
    }
}
