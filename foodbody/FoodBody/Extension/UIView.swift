//
//  UIView.swift
//  NEO
//
//  Created by Phuoc on 3/30/19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit

var gradientLayerKey = "gradientLayer"
var overlayViewKey = "overlayView"


extension UIView {
    
    func addShadowforview() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 8
    }
    
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 0.1]
       // gradientLayer.colors = define colors here
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addSmallGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 0.03]
         // gradientLayer.colors = define colors here
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    static var className: String {
        return NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
    
}

class OverlayView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        // Set màu cho context và đổ màu trắng toàn bộ view
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(bounds)
        // Set blend mode và màu trong suốt để chuẩn bị 'đục lỗ'
        context?.setBlendMode(.clear)
        context?.setFillColor(UIColor.clear.cgColor)
        // Tìm tất cả các subview của contentView, trừ chính overlay view và đổ màu trong suốt
        superview?.subviews.forEach({
            if $0 != self {
                context?.fill($0.frame)
            }
        })
    }
    
}

extension UIView {
    
    func startAnimationLoading() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.backgroundGray().cgColor,
            UIColor.lightGray().cgColor,
            UIColor.darkGray().cgColor,
            UIColor.lightGray().cgColor,
            UIColor.backgroundGray().cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: -0.85, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.15, y: 0)
        gradientLayer.locations = [-0.85, -0.85, 0, 0.15, 1.15]
        // Khởi tạo CABasicAnimation với keyPath muốn animate là `locations`
        let animation = CABasicAnimation(keyPath: "locations")
        // Giá trị `locations` bắt đầu animate
        animation.fromValue = gradientLayer.locations
        // Giá trị `locations` kết thúc animate
        animation.toValue = [0, 1, 1, 1.05, 1.15]
        // Lặp animation vô hạn
        animation.repeatCount = .infinity
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.duration = 1
        // Add animation cho gradient layer
        gradientLayer.add(animation, forKey: "what.ever.it.take")
        layer.addSublayer(gradientLayer)
        addOverlayView()
        objc_setAssociatedObject(self, &gradientLayerKey, gradientLayer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func stopAnimationLoading() {
        let overlayView = objc_getAssociatedObject(self, &overlayViewKey) as? OverlayView
        let gradientLayer = objc_getAssociatedObject(self, &gradientLayerKey) as? CAGradientLayer
        overlayView?.removeFromSuperview()
        gradientLayer?.removeFromSuperlayer()
    }
    
    private func addOverlayView() {
        let overlayView = OverlayView()
        overlayView.frame = bounds
        overlayView.backgroundColor = .clear
        addSubview(overlayView)
        objc_setAssociatedObject(self, &overlayViewKey, overlayView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
}
