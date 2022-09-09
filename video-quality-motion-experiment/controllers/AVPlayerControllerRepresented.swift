//
//  AVPlayerControllerRepresented.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 02.02.22.
//

import Foundation
import SwiftUI
import AVKit


/* use this to hide controls on video player, see: https://stackoverflow.com/questions/65927459/playback-controls-in-swiftui */

struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
