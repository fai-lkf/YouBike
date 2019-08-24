//
//  BikeLocationAPI.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import Moya

public enum BikeLocationAPI {
    case list
}

extension BikeLocationAPI: TargetType {
    
    public var path: String {
        switch self {
        case .list:
            return "/YouBikeTP.json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .list:
            return .get
        }
    }
}
