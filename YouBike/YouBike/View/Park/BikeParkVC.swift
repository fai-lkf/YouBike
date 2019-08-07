//
//  BikeLocationVC.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class BikeParkVC: BaseVC {
    
    var favouriteOnly = false
    
    static func create(favouriteOnly: Bool, vm: ViewModel<BikeParkVM>) -> BikeParkVC {
        let vc = BikeParkVC.xib()
        vc.favouriteOnly = favouriteOnly
        vc.vm = vm
        return vc
    }
    
    @IBOutlet weak var table: BaseTable!
    private lazy var btnRefresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
    
    override var isProcessing: [Driver<Bool>] { return [vm.isProcessing] }
    
    private var vm: ViewModel<BikeParkVM>!
    private lazy var adjust = PublishRelay<String>()
    private lazy var bookmark: Observable<[String]> = ParkBookmarkVM.shared.observe(.init(adjust: adjust.asObservable())).bookmarked
    
    override func setupUI() {
        
        navigationItem.do{
            $0.title = favouriteOnly ? "最愛列表" : "YouBike 停車場列表"
            $0.largeTitleDisplayMode = .always
            $0.rightBarButtonItems = [btnRefresh]
        }
        
        table.regsiter(nib: BikeParkCell.self)
    }
    
    override func setupRX() {
        let fetch = Observable.merge(
            btnRefresh.rx.tap.asObservable(),
            table.refresh.asObservable(),
            .just(())
        )
        
        let output = vm.observe(.init(fetch: fetch))
        
        let filterObs = Observable
            .combineLatest(
                bookmark,
                Observable.just(favouriteOnly)
            )
            .map{ $0.1 ? $0.0 : nil }
        
        Observable
            .combineLatest(
                output.parks,
                filterObs
            )
            .map{ parks, filter -> [BikePark] in
                guard let filter = filter else { return parks }
                return parks.filter{ filter.contains($0.sno) }
            }
            .map{ locs -> [(String, [BikePark])] in
                locs
                    .group{ $0.sarea }
                    .sorted(by: { (l1, l2) -> Bool in
                        return l1.key > l2.key
                    })
                    .map{
                        ($0.key,
                         $0.value.sorted(by: { p1, p2 -> Bool in
                            return p1.ar > p2.ar
                         }))
                }
            }
            .map{ $0.map{ SectionModel(model: $0.0, items: $0.1) } }
            .bind(to: table.rx.items(dataSource: dataSource()))
            .disposed(by: bag)
    }
    
    private func dataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, BikePark>> {
        return .init(configureCell: { [unowned self] (ds, tv, ip, model) -> UITableViewCell in
            let cell: BikeParkCell = tv.dequeue(for: ip)
            cell.set(model, selection: self.adjust, bookmark: self.bookmark)
            return cell
            }, titleForHeaderInSection: { (ds, s) -> String? in
                return ds[s].model
        })
    }
    
}
