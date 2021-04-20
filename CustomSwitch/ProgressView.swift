//
//  ProgressView.swift
//  CustomSwitch
//
//  Created by Samrith Yoeun on 20/4/21.
//

import UIKit

class ProgressView: UIControl {
  var startingAngle: CGFloat = 90 {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  var lineWidth: CGFloat = 30 {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  var guidLineColor: UIColor = UIColor.red.withAlphaComponent(0.2) {
    didSet {
      self.setNeedsDisplay()
    }
  }

  
  var progress: CGFloat  = 0 {
    willSet {
      var value = newValue
      if newValue > 1 {
        value = 1
      }
      
      if newValue < 0 {
        value = 0
      }
      
      self.progress = value
    }
    
    didSet {
      sendActions(for: .valueChanged)
      setNeedsDisplay()
    }
  }
  
  var timer: Timer?
  var timeLimit: TimeInterval = 3
  
  required convenience init(frame: CGRect, timeLimit: TimeInterval) {
    self.init(frame: frame)
    self.timeLimit = timeLimit
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    layer.cornerRadius = frame.height / 2
    clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    timer?.invalidate()
  }
  
  override func draw(_ rect: CGRect) {
  let context = UIGraphicsGetCurrentContext()
    context?.translateBy(x: 0, y: bounds.size.height)
    context?.scaleBy(x: 1, y: -1)
    context?.setLineWidth(lineWidth)
    
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let radius = bounds.midX - self.lineWidth / 2
    let arcStartAngle = Double((startingAngle + 360) ).radianValue
    let arcEndAngle = Double(startingAngle).radianValue
    let progressAngle = Double(360).radianValue * progress
    
    self.guidLineColor.set()
    context?.addArc(center: center,
                    radius: radius,
                    startAngle: arcStartAngle,
                    endAngle: arcEndAngle,
                    clockwise: true)
    context?.strokePath()
    
    self.tintColor.set()
    context?.addArc(center: center,
                    radius: radius,
                    startAngle: arcStartAngle,
                    endAngle: arcStartAngle - progressAngle,
                    clockwise: true)
    context?.strokePath()
  }

  func startAnimating() {
    progress = 0
    Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
      self.progress += CGFloat(1.0 / (self.timeLimit * 100))
      print("progress \(self.progress)")
      if self.progress >= 1 {
        timer.invalidate()
      }
    }
//    timer = Timer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
  }
  
  func stopAnimating() {
    timer?.invalidate()
  }
  
  @objc private func timerAction() {
    self.progress += CGFloat(1.0 / (self.timeLimit * 100))
    if self.progress >= 1 {
      timer?.invalidate()
    }
  }
}

private extension Double {
  var radianValue: CGFloat {
    return CGFloat(.pi * self / 180.0)
  }
}
