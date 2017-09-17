//
//  SineWaveView.swift
//  SineAnimationView
//
//  Created by Antonis papantoniou on 9/16/17.
//  Copyright © 2017 Antonis papantoniou. All rights reserved.
//

import UIKit

class SineWaveView: UIView {

  struct PathStyle {
    let color: UIColor
    let width: CGFloat
    init(_ color: UIColor, _ width: CGFloat) {
      self.color = color
      self.width = width
    }
  }

  var frequency: CGFloat = 1.5
  var idleAmplitude: CGFloat = 0.05
  var phaseShift: CGFloat = -0.15
  var density: CGFloat = 1.0

  var waves = [PathStyle(UIColor(valueRed: 109, green: 200, blue: 207), 6.0),
               PathStyle(UIColor(valueRed: 255, green: 255, blue: 255), 4.0),
               PathStyle(UIColor(valueRed: 255, green: 168, blue: 27), 2.2),
               PathStyle(UIColor(valueRed: 255, green: 255, blue: 255), 1.7)]

  var amplitude: CGFloat = 0.0 {
    didSet {
      amplitude = min(max(amplitude, idleAmplitude), 0.7)
      setNeedsDisplay()
    }
  }
  var phase: CGFloat = 0.0

  override func draw(_ rect: CGRect) {

    let context = UIGraphicsGetCurrentContext()
    context?.setAllowsAntialiasing(true)

    backgroundColor?.set()
    context?.fill(rect)

    let halfHeight = bounds.height / 2.0
    let maxAmplitude = halfHeight - waves[0].width

    for i in 0 ..< waves.count {
      let progress = 1.0 - CGFloat(i) / CGFloat(waves.count)
      let normedAmplitude = (1.8 * progress - 0.8) * amplitude
      let multiplier = min(1.0, (progress / 3.0 * 2.0) + (1.0 / 3.0))
      waves[i].color.withAlphaComponent(multiplier * waves[i].color.cgColor.alpha).set()
      drawWave(i, maxAmplitude: maxAmplitude, normedAmplitude: normedAmplitude)
    }
    phase += phaseShift
  }

  // Convenience function to draw the wave
  func drawWave(_ index: Int, maxAmplitude: CGFloat, normedAmplitude: CGFloat) {
    let path = UIBezierPath()
    let mid = bounds.width / 2.0

    path.lineWidth = waves[index].width

    for x in Swift.stride(from: 0, to: bounds.width + density, by: density) {
      // Parabolic scaling
      let scaling = -pow(1 / mid * (x - mid), 2) + 1
      let y = scaling * maxAmplitude * normedAmplitude
        * sin(CGFloat(2 * Double.pi) * frequency
          * (x / bounds.width) + phase) + bounds.height / 2.0
      if x == 0 {
        path.move(to: CGPoint(x: x, y: y))
      } else {
        path.addLine(to: CGPoint(x: x, y: y))
      }
    }

    //add straight line at the axis for fill mode.
    path.addLine(to: CGPoint(x: 0.0, y: bounds.height / 2))
    path.fill(with: .normal, alpha: 0.5)
    path.stroke()
  }
  
}

public extension UIColor {

  /// Initializes UIColor given RGB values between 0 and 255 inclusive, and optionally an alpha
  /// value between 0 and 1.0 inclusive.
  convenience init(valueRed red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0,
              blue: CGFloat(blue) / 255.0, alpha: alpha)
  }
  
}
