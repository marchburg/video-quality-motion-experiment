//
//  StimulusPresentation.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 17.12.21.
//

import SwiftUI
import AVKit
import Combine
import CoreMotion


struct StimulusPresentation: View {

    /* controls which view is presented in MainView */
    @Binding var selectNewParticipantId: Bool
    

    /* === participant data === */

    /* holds the data collected for one participant */
    @EnvironmentObject var participantData: ParticipantData
    
    /* === stimulus presentation === */

    /* contains the video player and notification when video ends */
    @EnvironmentObject var videoController: VideoController

    /* index of the video which is currently shown */
    @State var currentVideoIndex: Int = 0
    

    /* === motion detection === */

    /* The object for starting and managing motion services */
    // important: create only one CMMotionManager object for your app. Multiple instances of this class can affect the rate at which data is received from the accelerometer and gyroscope.
    let manager: CMMotionManager = CMMotionManager()

    /* Queue for processing the motion updates */
    let queue: OperationQueue = OperationQueue()

    /* the frequency of motion updates */
    let motionUpdateFrequency: Double = 1.0 / 60.0


    /* === additional overlay views === */

    /* controls if view with a button "ready" to start the video is shown */
    @State private var showAreYouReady: Bool = true

    /* controls if question on video content is shown */
    @State private var showQuestionVideoContent: Bool = false

    /* controls if questionnaire on quality is shown */
    @State private var showQuestionnaireQuality: Bool = false

    /* controls if questionnaire on emotion is shown */
    @State private var showQuestionnaireEmotion: Bool = false

    /* controls if questionnaire on emotion is shown */
    @State private var showQuestionnaireAdditional_1: Bool = false

    /* controls if questionnaire on emotion is shown */
    @State private var showQuestionnaireAdditional_2: Bool = false

    /* controls if a finish view with final questions is presented */
    @State private var showFinish: Bool = false

    /* controls if a export view is presented */
    @State private var showExport: Bool = false

    /* controls whether final screen is shown after last questionaire */
    @State var finalQuestionnairesFinished: Bool = false

    /* indicates whether this is final round of questionnaires after last video */
    @State var finalRoundQuestionnaires: Bool = false


    /* === functions === */

    /* Processing a Steady Stream of Motion Updates
     When you want to capture all of the device-motion data being generated, perhaps so you can analyze it for movement patterns, use the startDeviceMotionUpdates(using:to:withHandler:) or startDeviceMotionUpdates(to:withHandler:) method of CMMotionManager. These methods
     */
    func startQueuedUpdates() {

        /* establish network connection, open an output stream */
        // self.networkController.setupNetworkCommunication()

        /* check if device is able to detect motion data */
        if manager.isDeviceMotionAvailable {

            /* continuous number for each data sample */
            var sampleCount : Int = 0

            /* the frequency of motion updates */
            self.manager.deviceMotionUpdateInterval = self.motionUpdateFrequency

            /* ? not sure what this does */
            self.manager.showsDeviceMovementDisplay = true

            /*
            “start” method that takes an operation queue (instance of OperationQueue) and a block handler of a specific type for processing those updates. Pushes each new data set to your app by executing your handler block on the specified queue. The queueing of these blocks ensures that your app receives all of the motion data, even if your app becomes busy and is unable to process updates for a brief period of time.The motion data is passed into the block handler.
            */
            self.manager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: self.queue, withHandler: { (data, error) in

                /* Make sure the data is valid before accessing it. */
                if let validData = data {

                    /* increase number of this sample */
                    sampleCount += 1

                    /* create motion sample */
                    let motionSample: MotionSample = createMotionSample(data: validData, sampleCount: sampleCount)

                    /* create video sample */
                    let videoSample: VideoSample = createVideoSample(sampleCount: sampleCount)

                    /* create data sample combining motion and video data */
                    let dataSample: DataSample = DataSample(
                        participantId: self.participantData.participantId,
                        motionSample: motionSample,
                        videoSample: videoSample
                    )

                    /* append motion and video sample to participant data for export */
                    self.participantData.motionVideoData.append(dataSample)

                }
            })
        }
    }

    /* stop the stream of motion updates */
    func stopQueuedUpdates() {
        self.manager.stopDeviceMotionUpdates()
    }


    func createMotionSample(data: CMDeviceMotion, sampleCount: Int) -> MotionSample {

        /* create an object for this sample */
        let motionSample = MotionSample(
            timeStampPhone: formattedDateStringNow(),
            sampleCount: sampleCount,
            accelerationUserX: data.userAcceleration.x,
            accelerationUserY: data.userAcceleration.y,
            accelerationUserZ: data.userAcceleration.z,
            rotationRateX: data.rotationRate.x,
            rotationRateY: data.rotationRate.y,
            rotationRateZ: data.rotationRate.z
        )

        return motionSample
    }

    func createVideoSample(sampleCount: Int) -> VideoSample {

        let videoSample = VideoSample(
            timeStampPhone: formattedDateStringNow(),
            sampleCount: sampleCount,
            videoID: self.participantData.videoNames[currentVideoIndex],
            currentTimeVideo: String(CMTimeGetSeconds(self.videoController.player.currentTime()))
        )

        return videoSample
    }

    
    /* returns true and increments index of current video if there is a next video available */
    func checkNextVideoAvailable() -> Bool {
        
        /* total amount of videos for this participant */
        let amountVideos = self.participantData.videoNames.count
        
        if self.currentVideoIndex < amountVideos - 1 {
            return true
        } else {
            return false
        }
    }

    func loadNextVideoIntoPlayer(initialVideo: Bool) {
        
        print("loading next video with currentVideoIndex: \(self.currentVideoIndex)")
        
        /* try to find the url of the video in the bundle */
        if let videoUrl = Bundle.main.url(forResource: self.participantData.videoNames[initialVideo ? currentVideoIndex : currentVideoIndex + 1], withExtension: "mp4") {
            /* create an asset */
            let avAsset = AVAsset(url: videoUrl)
            /* Create an AVPlayerItem based on AvAsset */
            let avPlayerItem = AVPlayerItem(asset: avAsset)
            /* Set avPlayerItem to avPlayer */
            self.videoController.player.replaceCurrentItem(with: avPlayerItem)
        }
        /* or show a test video if the selected video is not available */
        else {
            let videoUrl = Bundle.main.url(forResource: "testVideo", withExtension: "mp4")!
            /* create an asset */
            let avAsset = AVAsset(url: videoUrl)
            /* Create an AVPlayerItem based on AvAsset */
            let avPlayerItem = AVPlayerItem(asset: avAsset)
            /* Set avPlayerItem to avPlayer */
            self.videoController.player.replaceCurrentItem(with: avPlayerItem)
        }
    }

    /* returns true if a next video was plugged into the player */
    func selectNextVideo() -> Bool {
        /* try to update index of current video to next video in selection */
        if self.checkNextVideoAvailable() {
            self.loadNextVideoIntoPlayer(initialVideo: false)
            return true
        }
        /* there are no more videos to show */
        else {
            return false
        }
    }

    /* called when a video has ended */
    func playerDidEnd() {

        /* show question on video content */
        self.showQuestionVideoContent = true

        /* see if next video can be selected */
        if !self.selectNextVideo() {
            self.finalRoundQuestionnaires = true
        }
    }

    var body: some View {

        VStack {

            /* use wrapped AVPlayerController to hide controls */
            AVPlayerControllerRepresented(player: self.videoController.player)
                // eyballed value to make video appear square
                .aspectRatio(0.75, contentMode: .fill)
                .onAppear(){
                    /* load first video */
                    self.loadNextVideoIntoPlayer(initialVideo: true)
                }
                /* receive notification when video has ended */
                .onReceive(self.videoController.playerDidFinishNotification) { _ in
                    self.playerDidEnd()
                }
                /* final questionnaire was finished (variable toggled in QuestionnaireEmotion) */
                .onChange(of: finalQuestionnairesFinished) { newValue in
                    /* stop sending motion data */
                    self.stopQueuedUpdates()
                    /* show finish view */
                    self.showFinish = true
                }
                /* show view Are You Ready */
                .fullScreenCover(isPresented: self.$showAreYouReady) {
                    AreYouReadyView()
                }
                /* show question video content */
                .fullScreenCover(isPresented: self.$showQuestionVideoContent) {
                    QuestionVideoContent(
                        showQuestionnaireQuality: self.$showQuestionnaireQuality
                    )
                }
                /* show questionnaire quality  */
                .fullScreenCover(isPresented: self.$showQuestionnaireQuality) {
                    QuestionnaireQuality(
                        showQuestionnaireEmotion: self.$showQuestionnaireEmotion
                    )
                }
                /* show questionnaire quality  */
                .fullScreenCover(isPresented: self.$showQuestionnaireEmotion) {
                    QuestionnaireEmotion(
                        showQuestionnaireAdditional_1: self.$showQuestionnaireAdditional_1
                    )
                }
                /* show questionnaire additional questions 1 */
                .fullScreenCover(isPresented: self.$showQuestionnaireAdditional_1) {
                    QuestionnaireAdditional_1(
                        showQuestionnaireAdditional_2: self.$showQuestionnaireAdditional_2
                    )
                }
                /* show questionnaire additional questions 2 */
                .fullScreenCover(isPresented: self.$showQuestionnaireAdditional_2) {
                    QuestionnaireAdditional_2(
                        currentVideoIndex: self.$currentVideoIndex,
                        showAreYouReady: self.$showAreYouReady,
                        finalRoundQuestionnaires: self.$finalRoundQuestionnaires,
                        finalQuestionnairesFinished: self.$finalQuestionnairesFinished
                    )
                }
                /* show finish view */
                .fullScreenCover(isPresented: self.$showFinish) {
                    Finish(showExport: self.$showExport)
                }
                /* show export view */
                .fullScreenCover(isPresented: self.$showExport) {
                    Export(selectNewParticipantId: self.$selectNewParticipantId)
                }

        }
        /* recognize tap gesture on elements in foreground */
        .onTapGesture {
            self.participantData.addTouchSample(locationTap: "StimulusPresentation_Screen")
        }
        /* recognizes touch input in the background */
        .background() {
            Color.clear
                /* necessary for clear color to detect touch input */
                .contentShape(Rectangle())
                /* recognize tap gesture */
                .onTapGesture {
                    self.participantData.addTouchSample(locationTap: "StimulusPresentation_Screen")
                }
        }
        .background() {
            /* blacks out white space on bottom and default sinfo on top of screen */
            Color.black.edgesIgnoringSafeArea([.top,.bottom])
        }
        /* start to send data when view appears */
        .onAppear{
            self.startQueuedUpdates()
        }

    }
}

struct StimulusPresentation_Previews: PreviewProvider {
    @State static var selectNewParticipantId: Bool = false
    static var previews: some View {
        StimulusPresentation(selectNewParticipantId: $selectNewParticipantId)
            .environmentObject(
                ParticipantData(
                    participantId: "XYZ",
                    videoNames: ["Story1_Part1_Q1"],
                    videoQuestions: ["what's up?"]
                )
            )
            .environmentObject(VideoController())
            .previewInterfaceOrientation(.portrait)
    }
}
