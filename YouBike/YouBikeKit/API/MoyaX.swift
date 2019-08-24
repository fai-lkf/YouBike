//
//  MoyaX.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa

extension TargetType {
    
    public var baseURL: URL { return try! "https://tcgbusfs.blob.core.windows.net/blobyoubike".asURL() }
    
    public var sampleData: Data { return Data() }
    public var headers: [String : String]?  { return nil }
    
    public var task: Task { return .requestPlain }
    
}
