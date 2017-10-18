import UIKit
import AVKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    
    @IBOutlet var playerView: AVPlayerLayerView!
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        playerView.setContentFile(file: (UserDefaults.standard.string(forKey: "file") ?? "8.mov") )
        playerView.play()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Device shaken.")
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) 
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
            let nav: UINavigationController = UINavigationController(rootViewController: vc)
            self.present(nav, animated: false, completion: nil)
        }
    }
}

//
//  AVPlayerLayerView.swift
//  from https://stackoverflow.com/questions/34569449/playback-video-in-ios-inside-a-custom-view
//  modified a bit by Wilsonator5000
//

class AVPlayerLayerView: UIView {
    var player: AVPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("AVPlayerLayerView -> init with frame")
        
        inits()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("AVPlayerLayerView -> init with coder")
        
        inits()
    }
    
    private func inits() {
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.frame = self.bounds
        self.layer.insertSublayer(avPlayerLayer, at: 0)
    }
    
//    func setContentUrl(url: NSURL) {
//        print("Setting up item: \(url)")
//        let item = AVPlayerItem(url: url as URL)
//        player.replaceCurrentItem(with: item)
//    }
    
    // Modified version:
    func setContentFile(file: String) {
        print("Setting up item: \(file)")
        let file = file.components(separatedBy: ".")
        let videoURL = AVPlayerItem(url: Bundle.main.url(forResource: file[0], withExtension: file[1])!)
        player.replaceCurrentItem(with: videoURL)
    }
    
    func play() {
        if (player.currentItem != nil) {
            print("Starting playback!")
            player.play()
        }
        
        //set a listener for when the video ends
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.rewind),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.player.currentItem)
    }
    
    func pause() {
        player.pause()
    }
    
    @objc func rewind() {
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        player.play()
    }
    
    func stop() {
        pause()
        rewind()
    }
}
