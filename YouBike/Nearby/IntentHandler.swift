//
//  IntentHandler.swift
//  Nearby
//
//  Created by LAU KIM FAI on 24/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        switch intent {
        case is NearbyParkIntent:
            return NearbyParkIntentHandler()
        default:
            return self
        }
    }
    
}

class NearbyParkIntentHandler: NSObject, NearbyParkIntentHandling  {
    
    func handle(intent: NearbyParkIntent, completion: @escaping (NearbyParkIntentResponse) -> Void) {
        
    }
}
