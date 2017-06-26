//
//  JellyEffectView.swift
//  JellyEffect
//
//  Created by dyLiu on 2017/6/22.
//  Copyright © 2017年 dyLiu. All rights reserved.
//

import UIKit

class JellyEffectView: UIView {

    let screenWidth:CGFloat = UIScreen.main.bounds.size.width
    let screenHeight:CGFloat = UIScreen.main.bounds.size.height
    
    let min_height:CGFloat = 100
    var m_height:CGFloat = 100
    
    var flectX:CGFloat = 0
    var flectY:CGFloat = 0

    var flectView:UIView = UIView()
    
    var shapeLayer:CAShapeLayer = CAShapeLayer()
    
    var displayLink:CADisplayLink?
    
    var isAnimating:Bool = false
    
    func reDrawFlectViewPath() {
        let layer:CALayer = self.flectView.layer.presentation()!
        self.flectX = layer.position.x
        self.flectY = layer.position.y
        updateShapePath()
    }
    
    func handlerPanGestureAction(_ pan:UIPanGestureRecognizer) {
        if false == isAnimating {
            
            if (pan.state == UIGestureRecognizerState.changed) {
                
                //手势滑动，取得滑动的点的位置
                let point:CGPoint = pan.location(in: self)
                debugPrint("\(point)")
                m_height = point.y*0.7 + min_height
                self.flectX = point.x// + screenWidth / 2.0
                self.flectY = m_height > min_height ? m_height : min_height
                self.flectView.frame = CGRect(x: self.flectX, y: self.flectY, width: self.flectView.frame.size.width, height: self.flectView.frame.size.height)
                
                updateShapePath()
                
            } else if (pan.state == UIGestureRecognizerState.cancelled || pan.state == UIGestureRecognizerState.ended || pan.state == UIGestureRecognizerState.failed) {
                //手势结束，shape弹性恢复原状
                isAnimating = true
                //屏幕刷新启动
                self.displayLink?.isPaused = false
                //弹性动效
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { 
                    self.flectView.frame = CGRect(x: self.screenWidth/2.0, y: self.min_height, width: self.flectView.frame.size.width, height: self.flectView.frame.size.height)
                }, completion: { (finish:Bool) in
                    if true == finish {
                        self.displayLink?.isPaused = true
                        self.isAnimating = false
                    }
                })
                
            }
            
            
        }
    }
    
    func updateShapePath() {
        let path:UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: screenWidth, y: 0))
        path.addLine(to: CGPoint(x: screenWidth, y: min_height))
        path.addQuadCurve(to: CGPoint(x: 0, y: min_height), controlPoint: CGPoint(x: self.flectX, y: self.flectY))
        path.close()
        self.shapeLayer.path = path.cgPath
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.shapeLayer.fillColor = UIColor.cyan.cgColor
        self.layer.addSublayer(self.shapeLayer)
        
        flectX = screenWidth / 2.0
        flectY = m_height
        self.flectView.frame = CGRect(x: flectX, y: flectY, width: 3, height: 3)
        self.flectView.backgroundColor = UIColor.clear
        self.addSubview(self.flectView)
        //滑动手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlerPanGestureAction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
        //刷新屏幕
        self.displayLink = CADisplayLink(target: self, selector: #selector(reDrawFlectViewPath))
        self.displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.displayLink?.isPaused = true
        //刷新shape
        updateShapePath()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
