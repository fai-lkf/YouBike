//
//  ParkLocationVC.swift
//  YouBike
//
//  Created by LAU KIM FAI on 8/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import UIKit
import MapKit
import RxDataSources
import RxSwift
import RxCocoa
import RxBinding

class ParkLocationVC: BaseVC {
    
    private var park: BikePark!
    private var vm: ViewModel<BikeParkVM>!
    convenience init(park: BikePark!, vm: ViewModel<BikeParkVM>) {
        self.init()
        self.park = park
        self.vm = vm
    }
    
    @IBOutlet weak var map: MKMapView!
    
    private lazy var btnRefresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
    override var isProcessing: [Driver<Bool>] { return [vm.isProcessing] }

    override func setupUI() {
        navigationItem.rightBarButtonItem = btnRefresh
        navigationItem.title = park.sna
        
        guard let camera = park.camera else { return }
        map.do{
            $0.setCamera(camera, animated: true)
            $0.addAnnotation(park.annotation)
        }
    }
    
    override func setupRX() {
    
        let output = vm.observe(.init(fetch: btnRefresh.rx.tap.asObservable()))
        
        let parkObs = Observable.merge(
            output.parks.map{ [weak self] in $0.first(where: { $0.sno == self?.park.sno }) },
            .just(park)
            )
            .filterNil()
        
        attachPullUp(controller: ParkDetailInfo(park: parkObs), sizes: [0.2, 0.5]) ~ bag
    }
}

class ParkDetailInfo: BaseVC {
    
    private var park: Observable<BikePark>!
    convenience init(park: Observable<BikePark>!) {
        self.init()
        self.park = park
    }
    
    private lazy var table = UITableView()
    
    override func setupUI() {
        view.addSubview(table)
        table.bounces = false
        table.snp.updateConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.left.right.bottom.equalToSuperview()
        }
        table.separatorStyle = .none
        table.register(nib: BikeParkCell.self)
    }
    
    override func setupRX() {
       park
            .map{ [SectionModel(model: "", items: [$0])] }
            ~> table.rx.items(dataSource: BikeParkCell.dataSource())
            ~ bag
    }
}
