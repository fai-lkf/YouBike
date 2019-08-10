//
//  BikeParkPadVC.swift
//  YouBike
//
//  Created by LAU KIM FAI on 9/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import RxBinding

class BikeParkPadVC: BikeParkVC {
    
    @IBOutlet weak var map: MKMapView!
    
    override func setupUI() {
        super.setupUI()
        map.delegate = self
    }
    
    override func setupRX() {
        super.setupRX()
        
        table.rx.modelSelected(BikePark.self)
            ~> currPark
            ~ bag
        
        currPark
            .filterNil()
            ~> map.rx.showPark
            ~ bag
        
        currPark
            .filterNil()
            .filter{ $0.camera == nil }
            .map{ $0.error }
            .bind(to: vm.error)
            .disposed(by: bag)
    }
    
}

extension BikeParkPadVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return annotation.bikePark
    }
}

extension Reactive where Base: MKMapView {
    
    var showPark: Binder<BikePark> {
        return Binder(base) { v, park in
            guard let camera = park.camera else { return }
            v.setCamera(camera, animated: true)
            v.annotations.forEach{ v.removeAnnotation($0) }
            v.addAnnotation(park.annotation)
        }
    }
    
}
