//
//  ViewController.swift
//  CustomSwitch
//
//  Created by Samrith Yoeun on 20/4/21.
//

import UIKit

class ViewController: UIViewController {
  var progressView: ProgressView!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let switchControl = SwitchView(frame: CGRect(x: 100, y: 100, width: 200, height: 40))
    switchControl.addTarget(self, action: #selector(valueChange(_:)), for: .valueChanged)
    self.view.addSubview(switchControl)
    
    progressView = ProgressView(frame: CGRect(x: 0, y: 200, width: 200, height: 200))
    progressView.tintColor = UIColor.red.withAlphaComponent(0.5)
    progressView.guidLineColor = UIColor.red.withAlphaComponent(0.1)
    progressView.progress = 0.1
    view.addSubview(progressView)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    progressView.startAnimating()
  }
  
  @objc func valueChange(_ sender: SwitchView) {
    print("value change \(sender.isOn)")
  }


}

