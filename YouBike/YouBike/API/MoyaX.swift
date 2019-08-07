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
    
    var baseURL: URL { return try! "https://tcgbusfs.blob.core.windows.net/blobyoubike".asURL() }
    
    var sampleData: Data { return Data() }
    
    var headers: [String : String]? { return nil }
    
    var task: Task { return .requestPlain }
    
}
