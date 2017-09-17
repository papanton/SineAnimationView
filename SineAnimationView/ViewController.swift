//
//  ViewController.swift
//  SineAnimationView
//
//  Created by Antonis papantoniou on 9/16/17.
//  Copyright © 2017 Antonis papantoniou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet var sineWaveView: SineWaveView!

  private var amplitude: CGFloat = 0.0
  private var waveTimer: Timer?
  private var increasing = true

  override func viewDidLoad() {
    super.viewDidLoad()
    startAnimations()
  }

  func updateAudioView(_:Timer) {
    sineWaveView.amplitude = amplitude
    amplitude = increasing ? amplitude + 0.01 : amplitude - 0.01
    if amplitude > 1.0 {
      increasing = false
    } else if amplitude < 0.3 {
      increasing = true
    }
  }

  func startAnimations() {
    guard waveTimer == nil else { return }
    waveTimer = Timer(timeInterval: 0.03, target: self,
                      selector: #selector(updateAudioView(_:)),
                      userInfo: nil, repeats: true)
    RunLoop.main.add(waveTimer!, forMode: RunLoopMode.commonModes)
  }

}

