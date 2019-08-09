//
//  UIX.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

extension NSObject: Namable {}

extension Reactive where Base: UIViewController {
    var navigate: Binder<UIViewController> {
        return Binder(base) { vc, target in
            target.hidesBottomBarWhenPushed = true
            vc.navigationController?.pushViewController(target, animated: true)
        }
    }
}

extension UIViewController {
    static func xib() -> Self { return self.init(nibName: name, bundle: nil) }
}

extension UIResponder {
    static func nib() -> UINib { return UINib(nibName: name, bundle: nil) }
}

extension CGColor {
    var uiColor: UIColor { return UIColor(cgColor: self) }
}

extension UITableView {
    func register(nib cell: UITableViewCell.Type) {
        register(cell.nib(), forCellReuseIdentifier: cell.name)
    }
    
    func register(class cell: UITableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.name)
    }
    
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.name, for: indexPath) as! T
    }
}

extension Reactive where Base: UIView {
    var onTap: Observable<Void> {
        return tapGesture()
            .when(.recognized)
            .map{ _ in () }
    }
}

extension Reactive where Base: UIImageView {
    var tintColor: Binder<UIColor?> {
        return Binder(base) { iv, tint in
            iv.tintColor = tint
        }
    }
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get { return layer.borderColor?.uiColor }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get { return layer.shadowColor?.uiColor }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension String {
    var image: UIImage? { return UIImage(named: self) }
}

extension UIViewController {
    
    func attachPullUp(controller: UIViewController, sizes: [CGFloat]) -> Disposable {
        
        let containerH = view.frame.height
        let maxH = Int(containerH * sizes.max()!)
        let gaps = sizes.map{ 1 - $0 }
        let maxGap = Int(containerH * gaps.max()!)
        let minGap = Int(containerH * gaps.min()!)
        let avgGap = (maxGap + minGap) / 2
        
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.snp.updateConstraints{
            $0.width.equalToSuperview()
            $0.height.equalTo(maxH)
            $0.top.equalToSuperview().offset(avgGap)
        }
        
        return controller.view.rx.panGesture()
            .when(.changed, .ended)
            .subscribe(onNext: { [weak view, weak controller] gesture in
                let offsetY = Int(gesture.translation(in: view).y * 0.2)
                switch gesture.state {
                case .changed:
                    let targetY = Int(controller?.view.frame.origin.y ?? 0) + offsetY
                    let gapY = offsetY < 0 ? max(minGap, targetY) : min(maxGap, targetY)
                    controller?.view.skTop(.init(gapY), duration: 0.1)
                case .ended:
                    let ratioY = (controller?.view.frame.origin.y ?? 0) / (view?.frame.height ?? 1)
                    let closetY = gaps.max(by: { abs($0 - ratioY) > abs($1 - ratioY) }) ?? 0
                    controller?.view.skTop(containerH * closetY, duration: 0.3)
                default:
                    return
                }
            })
    }
}

extension UIView {
    func skTop(_ offset: CGFloat, duration: TimeInterval) {
        snp.updateConstraints{
            $0.top.equalToSuperview().offset(offset)
        }
        needsUpdateConstraints()
        updateConstraintsIfNeeded()
        UIView.animate(withDuration: duration) { [weak superview] in
            superview?.layoutIfNeeded()
        }
    }
}
