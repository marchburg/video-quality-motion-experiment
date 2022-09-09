//
//  AreYouReadyView.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 19.01.22.
//

import SwiftUI
import AVFoundation

struct AreYouReadyView: View {
    
    /* used to close this view when opened in a sheet() */
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var videoController: VideoController
    
    /* holds the data collected for one participant */
    @EnvironmentObject var participantData: ParticipantData
    
    var body: some View {
        
        VStack {
            
            Button(action: {
                
                /* recognize tap gesture on this element */
                self.participantData.addTouchSample(locationTap: "AreYouReadyView_continueButton")
                
                /* close this view */
                self.presentationMode.wrappedValue.dismiss() // iOS <15
                
                /* start to play video */
                self.videoController.player.play()
                
            }) {
                ButtonTextFullWidth(text: "Start")
            }
            
        }
        /* expand view to detect tap gesture on entire screen */
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        /* recognize tap gesture on elements in foreground */
        .onTapGesture {
            self.participantData.addTouchSample(locationTap: "AreYouReady_Screen")
        }
        /* recognizes touch input in the background */
        .background() {
            Color.clear
                /* necessary for clear color to detect touch input */
                .contentShape(Rectangle())
                /* recognize tap gesture */
                .onTapGesture {
                    self.participantData.addTouchSample(locationTap: "AreYouReady_Screen")
                }
        }
        
    }
}

struct AreYouReadyView_Previews: PreviewProvider {
    @State static var player: AVPlayer = AVPlayer()
    static var previews: some View {
        AreYouReadyView(/*player: $player*/)
            .environmentObject(VideoController())
            .environmentObject(
                ParticipantData(
                    participantId: "XYZ",
                    videoNames: ["Story1_Part1_Q1"],
                    videoQuestions: ["what's up?"]
                )
            )
    }
}
