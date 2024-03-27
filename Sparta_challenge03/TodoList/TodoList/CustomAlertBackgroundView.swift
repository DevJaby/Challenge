//
//  CustomAlertBackgroundView.swift
//  TodoList
//
//  Created by Jeong-bok Lee on 3/26/24.
//

import UIKit

class CustomAlertBackgroundView: UIView {
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 42)
    let layer = CALayer()
    layer.shadowPath = shadowPath.cgPath
    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 16
    layer.shadowOffset = CGSize(width: 0, height: 8)
    layer.bounds = bounds
    layer.position = center
    layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.82).cgColor
    self.layer.addSublayer(layer)
  }
}
