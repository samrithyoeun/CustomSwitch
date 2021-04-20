//
//  SwitchView.swift
//  CustomSwitch
//
//  Created by Samrith Yoeun on 20/4/21.
//

import UIKit

class SwitchView: UIControl {
  lazy var thumbView = createThumbView()
  lazy var onStatusView = createOnStatusView()
  lazy var offStatusView = createOffStatusView()
  
  var verticalMargin: CGFloat = 8
  var horizontalMargin: CGFloat = 8
  
  var isOn = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func createOnStatusView() -> UIView {
    let onStatusView = UIView(frame: self.bounds)
    onStatusView.layer.cornerRadius = onStatusView.bounds.height / 2
    onStatusView.backgroundColor = .green
    return onStatusView
  }
  
  func createOffStatusView() -> UIView {
    let offStatusView = UIView(frame: self.bounds)
    offStatusView.layer.cornerRadius = offStatusView.bounds.height / 2
    offStatusView.backgroundColor = .red
    return offStatusView
  }
  
  func createThumbView() -> UIView {
    let thumbView = UIView(frame: CGRect(x: horizontalMargin / 2 ,
                                     y: verticalMargin / 2,
                                     width: self.bounds.height - verticalMargin,
                                     height: self.bounds.height - verticalMargin))
    
    thumbView.layer.cornerRadius = thumbView.frame.height / 2
    thumbView.backgroundColor = .white
    thumbView.layer.borderColor = UIColor.lightGray.cgColor
    thumbView.layer.borderWidth = 0.3
    return thumbView
  }
  
  func setup() {
    addSubview(onStatusView)
    addSubview(offStatusView)
    addSubview(thumbView)
    setupGestureRecognizer()
  }
  
  private func setupGestureRecognizer() {
    let thumbViewTap = UITapGestureRecognizer(target: self, action: #selector(didTappedOnThumbView(_:)))
    thumbViewTap.delegate = self
    thumbView.addGestureRecognizer(thumbViewTap)
    
    let backgroundTapping = UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView(_:)))
    backgroundTapping.delegate = self
    self.addGestureRecognizer(backgroundTapping)
    
    let thumbViewPan = UIPanGestureRecognizer(target: self, action: #selector(didPannedOnThumbView(_:)))
    thumbViewPan.delegate = self
    thumbView.addGestureRecognizer(thumbViewPan)
    
  }
  
  @objc private func didTappedOnThumbView(_ gesture: UITapGestureRecognizer) {
    
  }
  
  @objc private func didTappedOnBackgroundView(_ gesture: UITapGestureRecognizer) {
    if gesture.state == .ended {
      moveThumbView()
    }
  }
  
  @objc private func didPannedOnThumbView(_ gesture: UIPanGestureRecognizer) {
    
  }
  
  private func animate(to centerPoint: CGPoint, duration: TimeInterval = 0.3, isOn: Bool) {
    if isOn {
      onStatusView.alpha = 1
      offStatusView.alpha = 0
      
    } else {
      onStatusView.alpha = 0
      offStatusView.alpha = 1
    }
    
    UIView.animate(withDuration: duration,
                   delay: 0.05,
                   options: .curveEaseOut,
                   animations: {
                    self.thumbView.center = centerPoint
                   },
                   completion: { finish in
                    if finish {
                      self.isOn = isOn
                      self.notifyValueChange()
                    }
                   })
  }
  
  private func moveThumbView() {
    isOn
      ? animate(to: CGPoint(x: (thumbView.frame.size.width + horizontalMargin)/2 , y: thumbView.center.y), isOn: false)
      : animate(to: CGPoint(x: (onStatusView.frame.width - (thumbView.frame.width + horizontalMargin)/2) , y: thumbView.center.y), isOn: true)
  }
  
  private func notifyValueChange() {
    sendActions(for: .valueChanged)
  }
  
}

extension SwitchView: UIGestureRecognizerDelegate {}

