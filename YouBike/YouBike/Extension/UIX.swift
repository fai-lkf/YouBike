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
    public var navigate: Binder<UIViewController> {
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
    public var uiColor: UIColor { return UIColor(cgColor: self) }
}

extension UITableView {
    public func register(nib cell: UITableViewCell.Type) {
        register(cell.nib(), forCellReuseIdentifier: cell.name)
    }
    
    public func register(class cell: UITableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.name)
    }
    
    public func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.name, for: indexPath) as! T
    }
}

extension Reactive where Base: UIView {
    public var onTap: Observable<Void> {
        return tapGesture()
            .when(.recognized)
            .map{ _ in () }
    }
}

extension Reactive where Base: UIImageView {
    public var tintColor: Binder<UIColor?> {
        return Binder(base) { iv, tint in
            iv.tintColor = tint
        }
    }
}

extension UIView {
    @IBInspectable
    public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    public var borderColor: UIColor? {
        get { return layer.borderColor?.uiColor }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    public var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    public var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    public var shadowColor: UIColor? {
        get { return layer.shadowColor?.uiColor }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension String {
    public var image: UIImage? { return UIImage(named: self) }
}
