//
//  BikeParkCell.swift
//  YouBike
//
//  Created by LAU KIM FAI on 7/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxBinding

class BikeParkCell: BaseCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var vStatus: UIView!
    @IBOutlet weak var lblOccupancy: UILabel!
    @IBOutlet weak var lblAvailability: UILabel!
    @IBOutlet weak var lblLastUpdate: UILabel!
    @IBOutlet weak var imgStar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgStar.do{
            $0.image = imgStar.image?.withRenderingMode(.alwaysTemplate)
            $0.transform = .init(rotationAngle: .pi / 2)
        }
    }
    
    private var model: BikePark? {
        didSet {
            guard let park = model else { return }
            
            lblName.text = park.sna
            lblAddress.text = park.ar
            lblTotal.text = "停車格: \(park.total)"
            lblLastUpdate.text = "最後更新於: \("yyyyMMddHHmmss".df.date(from: park.mday)?.yyyy_MM_dd_HH_mm_ss ?? "")"
            
            vStatus.isHidden = park.total == 0
            guard park.total != 0 else { return }
            
            lblOccupancy.do{
                $0.text = "\(park.occupancy) 已佔用"
                let occupied = (park.occupancy.d / park.total.d).rounded(2)
                $0.snp.remakeConstraints{
                    $0.width.equalToSuperview().multipliedBy(occupied)
                }
            }
            lblAvailability.text = "\(park.availability) 可用"
        }
    }
    
    private let (adjust, bookmark) = ParkBookmarkVM.request()
    
    func set(_ park: BikePark) {
        model = park
        
        imgStar.rx.onTap.map{ park.sno }
            ~> adjust
            ~ bag
        
        bookmark.map{ $0.contains(park.sno) ? UIColor.blue : .gray }
            ~> imgStar.rx.tintColor
            ~ bag
    }
    
}

extension BikeParkCell {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, BikePark>> {
        return .init(configureCell: { (ds, tv, ip, model) -> UITableViewCell in
            let cell: BikeParkCell = tv.dequeue(for: ip)
            cell.set(model)
            return cell
        }, titleForHeaderInSection: { (ds, s) -> String? in
            return ds[s].model
        }, canEditRowAtIndexPath: { (ds, ip) -> Bool in
            return true
        })
    }
}
