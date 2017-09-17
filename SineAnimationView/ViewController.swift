//
//  ViewController.swift
//  SineAnimationView
//
//  Created by Antonis papantoniou on 9/16/17.
//  Copyright © 2017 Antonis papantoniou. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

  @IBOutlet var sineWaveView: SineWaveView!

  private var amplitude: CGFloat = 0.0
  private var waveTimer: Timer?
  private var increasing = true

  private var session: AVAudioSession?
  private var record: AVAudioRecorder?

  override func viewDidLoad() {
    super.viewDidLoad()
    session = AVAudioSession.sharedInstance()
    try? session?.setCategory(AVAudioSessionCategoryRecord)
    try? session?.setActive(true)

    let settings = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

    record = try? AVAudioRecorder(url: audioFilename, settings: settings)
    startRecording()
    startAnimations()
  }

  func startRecording() {
    if session?.recordPermission() == .granted {
      record?.record()
      record?.isMeteringEnabled = true
    }
    session?.requestRecordPermission() { [weak self] granted in
      if !granted {
        print("need record permission to start animation")
      } else {
        self?.record?.record()
      }
    }
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }

  func updateAudioView(_:Timer) {
    if let record = record, record.isRecording {
      record.updateMeters()
      let peak = record.peakPower(forChannel: 0)
      sineWaveView.amplitude = CGFloat(0.8 - peak / -60)
      return
    }
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

