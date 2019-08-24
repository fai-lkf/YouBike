//
//  IntentViewController.swift
//  NearbyUI
//
//  Created by LAU KIM FAI on 24/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import IntentsUI
import RxCoreLocation
import CoreLocation
import RxSwift
import RxCocoa
import RxOptional
import YouBikeKit

class SubtitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var table: UITableView!
    private lazy var manager = CLLocationManager()
    private lazy var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table?.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "SubtitleTableViewCell")
    }
    
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        
        guard
            let response = interaction.intentResponse as? NearbyParkIntentResponse,
            let parks = response.parks?.compactMap({ $0.bikePark }),
            parks.isNotEmpty
            else { return completion(false, parameters, desiredSize) }
        
        manager.rx.location
            .filterNil()
            .take(1)
            .do(onNext: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    completion(true, parameters, self?.table.contentSize ?? .zero)
                }
            })
            .map{ loc -> [LocBikePark] in
                parks
                    .sorted(by: { p1, p2 -> Bool in
                        guard let l1 = p1.coordiante?.location else { return false }
                        guard let l2 = p2.coordiante?.location else { return true }
                        return loc.distance(from: l1) < loc.distance(from: l2)
                    })
                    .map{ LocBikePark(curr: loc, park: $0) }
            }
            .map{ Array($0.prefix(5)) }
            .bind(to: table.rx.items(cellIdentifier: "SubtitleTableViewCell", cellType: SubtitleTableViewCell.self)) { _, model, cell in
                let park = model.park
                let curr = model.curr
                cell.textLabel?.do{
                    $0.text = park.ar
                    $0.numberOfLines = 0
                }
                let km = (park.coordiante?.location.distance(from: curr) ?? 0) / 1000
                
                cell.detailTextLabel?.do{
                    $0.text = [
                        "距離: \(km.rounded(1)) 公里",
                        "空位: \(park.availability)"
                        ]
                    .joined(separator: "\n")
                    $0.numberOfLines = 0
                }
            }
            .disposed(by: bag)
        
        manager.startUpdatingLocation()
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
}

struct LocBikePark {
    let curr: CLLocation
    let park: BikePark
}

extension Double {
    func rounded(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
