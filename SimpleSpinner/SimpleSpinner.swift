//
//  SimpleSpinner.swift
//  Broomy
//
//  Created by Arturo Guerrero on 04/03/17.
//  Copyright © 2017 Mega Apps. All rights reserved.
//

import UIKit
import QuartzCore

class SimpleSpinner: UIView {
    
    enum SimpleSpinnerKey : String {
        case StrokeAnimation = "StrokeAnimation"
        case RotationAnimation = "RotationAnimation"
    }
    
    let ResetAnimationsNotification = NSNotification.Name(rawValue: "ResetAnimationsNotification")
    
    public var timingFunction: CAMediaTimingFunction!
    public var duration: TimeInterval!
    
    lazy private var progressLayer: CAShapeLayer = {
        let _progressLayer = CAShapeLayer()
        _progressLayer.strokeColor = self.tintColor.cgColor
        _progressLayer.fillColor = nil
        _progressLayer.lineWidth = 1.5
        return _progressLayer
    }()
    public var isAnimating: Bool = false
    public var lineWidth: CGFloat! {
        get {
            return self.progressLayer.lineWidth
        }
        set(newValue) {
            self.progressLayer.lineWidth = newValue
            self.updatePath()
        }
    }
    public var hidesWhenStopped: Bool = true {
        didSet {
            self.isHidden = !self.isAnimating && hidesWhenStopped
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override func awakeFromNib() {
        self.initialize()
    }
    
    func initialize() {
        self.duration = 1.5
        self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.layer.addSublayer(self.progressLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SimpleSpinner.resetAnimations), name: ResetAnimationsNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.progressLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.updatePath()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.progressLayer.strokeColor = self.tintColor.cgColor
    }
    
    func resetAnimations() {
        if self.isAnimating {
            self.stopAnimating()
            self.startAnimating()
        }
    }
    
    public func setAnimating(_animate: Bool) {
        _animate ? self.startAnimating() : self.stopAnimating()
    }
    
    
    public func startAnimating() {
        if self.isAnimating {
            return
        }
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = self.duration / 0.375
        animation.fromValue = 0
        animation.toValue = 2 * M_PI
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        self.progressLayer.add(animation, forKey: SimpleSpinnerKey.RotationAnimation.rawValue)
        
        let headAnimation = CABasicAnimation()
        headAnimation.keyPath = "strokeStart"
        headAnimation.duration = self.duration / 1.5
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = self.timingFunction
        
        let tailAnimation = CABasicAnimation()
        tailAnimation.keyPath = "strokeEnd"
        tailAnimation.duration = self.duration / 1.5
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        tailAnimation.timingFunction = self.timingFunction
        
        
        let endHeadAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = "strokeStart"
        endHeadAnimation.beginTime = self.duration / 1.5
        endHeadAnimation.duration = self.duration / 3.0
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1
        endHeadAnimation.timingFunction = self.timingFunction
        
        let endTailAnimation = CABasicAnimation()
        endTailAnimation.keyPath = "strokeEnd"
        endTailAnimation.beginTime = self.duration / 1.5
        endTailAnimation.duration = self.duration / 3.0
        endTailAnimation.fromValue = 1
        endTailAnimation.toValue = 1
        endTailAnimation.timingFunction = self.timingFunction
        
        let animations = CAAnimationGroup()
        animations.duration = self.duration
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = Float.infinity
        animations.isRemovedOnCompletion = false
        self.progressLayer.add(animations, forKey: SimpleSpinnerKey.StrokeAnimation.rawValue)
        
        self.isAnimating = true
        
        if self.hidesWhenStopped {
            self.isHidden = false
        }
    }
    
    public func stopAnimating() {
        if !self.isAnimating {
            return
        }
        
        self.progressLayer.removeAnimation(forKey: SimpleSpinnerKey.RotationAnimation.rawValue)
        self.progressLayer.removeAnimation(forKey: SimpleSpinnerKey.StrokeAnimation.rawValue)
        self.isAnimating = false
        
        if (self.hidesWhenStopped) {
            self.isHidden = true
        }
        
    }
    
    private func updatePath() {
        
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = min(self.bounds.width / 2, self.bounds.height / 2) - self.progressLayer.lineWidth / 2
        let startAngle = CGFloat(0)
        let endAngle = CGFloat(2*M_PI)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        self.progressLayer.path = path.cgPath
        
        self.progressLayer.strokeStart = 0
        self.progressLayer.strokeEnd = 0
        
        self.layoutIfNeeded()
        
    }
}
