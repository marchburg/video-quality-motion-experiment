//
//  VideoController.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 26.01.22.
//

import Foundation
import SwiftUI
import AVFoundation

class VideoController: ObservableObject {
    
    let player: AVPlayer = AVPlayer()

    let playerDidFinishNotification = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
    
}
