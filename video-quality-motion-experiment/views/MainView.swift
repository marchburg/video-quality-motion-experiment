//
//  MainView.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 30.11.21.
//

import SwiftUI

struct MainView: View {

    /* control if view to select a participant id is show before starting a new experiment run */
    @State var selectNewParticipantId: Bool = true

    /* the selected participant id */
    @State var participantId: String = ""

    /* object that holds the video player and notifications for it */
    @EnvironmentObject var videoController: VideoController

    /* specifications for each participant including id, which video, video qualites, questions on videos */
    let participantSpecifications: [ParticipantSpecification] = loadCSV(from: "participant_orders_semikolon")

    /* returns either the view to select a participant id or the view(s) for one experiment run */
    private func containedView() -> AnyView {
        /* show view to enter participant id if value of participantId is -1 */
        if self.selectNewParticipantId {
            return AnyView(
                EnterParticipantId(
                    participantId: self.$participantId,
                    selectNewParticipantId: self.$selectNewParticipantId,
                    participantSpecifications: self.participantSpecifications
                )
            )
        } else {
            return AnyView(
                /* show the view for one experiment */
                StimulusPresentation(
                    selectNewParticipantId: $selectNewParticipantId
                )
                /* create a new object for saving data of one participant */
                .environmentObject(
                    ParticipantData(
                        participantId: self.participantId,
                        /* get the participant with chosen id and get names of videos intended for this participant id */
                        videoNames: self.participantSpecifications.filter{$0.pid == self.participantId}[0].getVideoNamesMobileStory(),
                        /* get questions intended for this participant id */
                        videoQuestions: self.participantSpecifications.filter{$0.pid == self.participantId}[0].getVideoQuestionsMobileStory()
                    )
                )
            )
        }
    }

    var body: some View {

        VStack {
            containedView()
        }

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .environmentObject(VideoController())
        }
    }
}
