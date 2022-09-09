//
//  video_quality_motion_experimentApp.swift
//  video-quality-motion-experiment
//
//  Created by Martin Burghart on 07.09.22.
//

import SwiftUI

@main
struct video_quality_motion_experimentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            /* entry point */
            MainView()
                .environmentObject(VideoController())
            
        }
    }
}
