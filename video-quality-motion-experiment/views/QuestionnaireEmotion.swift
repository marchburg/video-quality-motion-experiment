//
//  QuestionnaireEmotion.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 19.01.22.
//

import SwiftUI

struct QuestionnaireEmotion: View {

    /* used to close this view when shown as sheet / fullScreenCover */
    @Environment(\.dismiss) var dismiss // iOS15+

    /* valence is based on xTap location divided by width of affect grid */
    @State var valence: Double = -999
    @State var arousal: Double = -999

    /* controls if next view with additional questions is shown */
    @Binding var showQuestionnaireAdditional_1: Bool

    /* participant data */
    @EnvironmentObject var participantData: ParticipantData

    @State var showAlert: Bool = false

    func saveAndContinue() {
        /* save data */
        self.participantData.questionnaireData[self.participantData
                                                .questionnaireIndex].valence = self.valence
        self.participantData.questionnaireData[self.participantData
                                                .questionnaireIndex].arousal = self.arousal


        /* close this view */
        dismiss()

        /* show next screen with additional questions */
        self.showQuestionnaireAdditional_1 = true
    }

    var body: some View {
        VStack {

            Spacer()

            Text("Wie fühlst du dich?")
                .font(.title)

            Spacer()

            /* affect grid */
            AffectGrid(
                valence: $valence,
                arousal: $arousal
            )

            Spacer()

            /* "continue" button */
            Button(action: {
                
                /* recognize tap gesture on this element */
                self.participantData.addTouchSample(locationTap: "Emotion_continueButton")

                /* check if answer was given */
                if self.valence == -999 {
                    self.showAlert = true
                } else {
                    self.saveAndContinue()
                }

            }) {
                ButtonTextFullWidth(text: "Weiter")
            }
            .alert(isPresented: self.$showAlert) {
                Alert(
                    title: Text("Du hast die Frage nicht beantwortet").font(.title),
                    message: Text("Bitte beantworte die Frage").font(.title),
                    primaryButton: .cancel(Text("Frage beantworten")) {
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Emotion_Alert_cancelButton")
                        
                    },
                    secondaryButton: .destructive(Text("Trotzdem fortfahren")) {
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Emotion_Alert_continueButton")
                        
                        /* go next screen even if not all questions were answered */
                        self.saveAndContinue()
                    }
                )
            }

        }
        /* recognize tap gesture on elements in foreground */
        .onTapGesture {
            self.participantData.addTouchSample(locationTap: "Emotion_Screen")
        }
        /* recognizes touch input in the background */
        .background() {
            Color.clear
                /* necessary for clear color to detect touch input */
                .contentShape(Rectangle())
                /* recognize tap gesture */
                .onTapGesture {
                    self.participantData.addTouchSample(locationTap: "Emotion_Screen")
                }
        }
        
    }
}

struct QuestionnaireEmotion_Previews: PreviewProvider {
    @State static var showQuestionnaireAdditional_1: Bool = false

    static var previews: some View {
        QuestionnaireEmotion(showQuestionnaireAdditional_1: $showQuestionnaireAdditional_1)
            .environmentObject(
                ParticipantData(
                    participantId: "XYZ",
                    videoNames: ["Story1_Part1_Q1"],
                    videoQuestions: ["what's up?"]
                )
            )
    }
}
