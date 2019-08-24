//
//  IntentHandler.swift
//  Nearby
//
//  Created by LAU KIM FAI on 24/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import Intents
import RxSwift
import CoreLocation
import RxCocoa
import RxOptional
import YouBikeKit
import Moya

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any? {
        switch intent {
        case is NearbyParkIntent:
            return NearbyParkIntentHandler()
        default:
            return self
        }
    }
}

class NearbyParkIntentHandler: NSObject, NearbyParkIntentHandling {
    
    private lazy var api: MoyaProvider<BikeLocationAPI> = .init()
    
    func confirm(intent: NearbyParkIntent, completion: @escaping (NearbyParkIntentResponse) -> Void) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            completion(.init(code: .ready, userActivity: nil))
        default:
            let res: NearbyParkIntentResponse = .init(code: .failure, userActivity: nil)
            res.errorMessage = "未有開啟定位功能"
            completion(res)
        }
    }
    
    func handle(intent: NearbyParkIntent, completion: @escaping (NearbyParkIntentResponse) -> Void) {
        
        _ = api.rx.request(.list)
            .debug("@#")
            .map(BikeParkResponse.self)
            .map{ $0.retVal.map{ $0.value } }
            .subscribe(
                onSuccess: { parks in
                    let res: NearbyParkIntentResponse = .init(code: .success, userActivity: nil)
                    res.parks = parks.map{ INBikePark(park: $0) }
                    //                    res.availbility = NSNumber(value: parks.count)
                    completion(res)
            },
                onError: {
                    let res: NearbyParkIntentResponse = .init(code: .failure, userActivity: nil)
                    res.errorMessage = $0.localizedDescription
                    completion(res)
            })
    }
}
