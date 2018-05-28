//
//  AudioPlayerViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/7/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {
    @IBOutlet weak var lessonTitle: UILabel!
    @IBOutlet weak var lessonImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var audioLengthLabel: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    var introLesson: [String: String]!
    var thinkingPatternsLesson: [String: String]!
    var audioPlayer: AVPlayer?
    var playerItem: AVPlayerItem?
    
    var tag: Int = 0
    var path: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tag == 1 {
            lessonTitle.text = introLesson["introTitle"]
            lessonImageView.image = UIImage(named: introLesson["introAudioImage"]!)
            let path = introLesson["introVideoURL"]!
            setupPlayerView(url: path)
        }
            
        else if tag == 2 {
            lessonTitle.text = thinkingPatternsLesson["thinkingPatternTitle"]
            lessonImageView.image = UIImage(named: thinkingPatternsLesson["thinkingAudioImage"]!)
            //Insert path code here once audio files are set up.
        }
        
        audioSlider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        audioSlider.isContinuous = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @objc func handleSliderChange() {
        if let duration = audioPlayer?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(audioSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            audioPlayer?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //perhaps do something later here
            })
        }
    }

    func setupPlayerView(url: String) {
        if let urlString = URL(string: url) {
            playerItem = AVPlayerItem(url: urlString)
            audioPlayer = AVPlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: audioPlayer)
            playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
            self.view.layer.addSublayer(playerLayer)
            audioPlayer?.play()
        }
        audioPlayer?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        //Track player progress.
        let interval = CMTime(value: 1, timescale: 2)
        audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds) % 60)
            let minutesString = String(format: "%02d", Int(seconds) / 60)
            self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
            
                //Moving slider thumb position.
                if let duration = self.audioPlayer?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.audioSlider.value = Float(seconds / durationSeconds)
                    UIView.animate(withDuration: 0.1/2, delay: 0, options: .curveLinear, animations: {
                        self.audioSlider.setValue(self.audioSlider.value, animated:true)
                    }, completion: nil)
             }
        })
    }


    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            if let duration = audioPlayer?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                audioLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }


    @IBAction func closeButtonTapped(_ sender: Any) {
        audioPlayer?.pause()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if audioPlayer!.rate == 0 {
            audioPlayer?.play()
            playButton.setImage(UIImage (named: "pause"), for: .normal)
            //playButton.setTitle("Pause", for: .normal)
        }
        else {
            audioPlayer?.pause()
            playButton.setImage(UIImage (named: "play"), for: .normal)
            //playButton.setTitle("Play", for: .normal)
        }
    }
    
    @IBAction func animateSlider(_ sender: Any) {
    }
    
    fileprivate let seekDuration: Float64 = 15
    @IBAction func rewindButtonTapped(_ sender: Any) {
        let playerCurrentTime = CMTimeGetSeconds((audioPlayer?.currentTime())!)
        var newTime = playerCurrentTime - seekDuration
        
        if newTime < 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
        audioPlayer?.seek(to: time2, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        guard let duration  = audioPlayer?.currentItem?.duration else{
            return
        }
        let playerCurrentTime = CMTimeGetSeconds((audioPlayer?.currentTime())!)
        let newTime = playerCurrentTime + seekDuration
        
        if newTime < (CMTimeGetSeconds(duration) - seekDuration) {
            
            let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
            audioPlayer?.seek(to: time2, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
}


