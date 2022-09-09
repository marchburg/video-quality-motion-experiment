//
//  QuestionVideoContent.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 23.02.22.
//

import SwiftUI

struct QuestionVideoContent: View {

    /* used to close this view when shown as sheet / fullScreenCover */
    @Environment(\.dismiss) var dismiss // iOS15+

    /* controls if questionnaire on quality is shown */
    @Binding var showQuestionnaireQuality: Bool

    /* participant data */
    @EnvironmentObject var participantData: ParticipantData

    var body: some View {
        VStack {

            Spacer()

            Text("Bitte beantworte folgende Frage:")
                .font(.title3)
                .bold()
                .padding()

            Text(self.participantData.getCurrentQuestionVideoContent())
                .font(.title3)
                .padding()

            Spacer()

            /* "continue" button */
            Button(action: {
                
                /* recognize tap gesture on this element */
                self.participantData.addTouchSample(locationTap: "QuestionVideoContent_ContinueButton")

                /* continue to questionnaire on quality */
                self.showQuestionnaireQuality = true

                /* close this view */
                dismiss()

            }) {
                ButtonTextFullWidth(text: "Weiter")
            }

        }
        /* recognize tap gesture on elements in foreground */
        .onTapGesture {
            self.participantData.addTouchSample(locationTap: "QuestionVideoContent_Screen")
        }
        /* recognizes touch input in the background */
        .background() {
            Color.clear
                /* necessary for clear color to detect touch input */
                .contentShape(Rectangle())
                /* recognize tap gesture */
                .onTapGesture {
                    self.participantData.addTouchSample(locationTap: "QuestionVideoContent_Screen")
                }
        }
    }
}

struct QuestionVideoContent_Previews: PreviewProvider {
    @State static var showQuestionnaireQuality: Bool = false
    static var previews: some View {
        QuestionVideoContent(showQuestionnaireQuality: $showQuestionnaireQuality)
            .environmentObject(
                ParticipantData(
                    participantId: "XYZ",
                    videoNames: ["Story1_Part1_Q1"],
                    videoQuestions: ["what's up?"]
                )
            )
    }
}
