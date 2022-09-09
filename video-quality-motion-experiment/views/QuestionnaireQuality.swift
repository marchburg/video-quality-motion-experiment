//
//  QuestionnaireQuality.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 19.01.22.
//

import SwiftUI

struct QuestionnaireQuality: View {

    /* used to close this view when shown as sheet / fullScreenCover */
    @Environment(\.dismiss) var dismiss // iOS15+

    /* controls if questionnaire on emotion is shown in stimulus presentation view */
    @Binding var showQuestionnaireEmotion: Bool

    /* participant data */
    @EnvironmentObject var participantData: ParticipantData

    /* holds the audioQuality set by slider */
    @State var audioQuality: Double = 0

    /* holds the audioQuality set by slider */
    @State var videoQuality: Double = 0

    /* holds the overallQuality set by slider */
    @State var overallQuality: Double = 0

    /* controls if alert is shown that questions have not been answered yet */
    @State var showAlert: Bool =  false

    /* control if Sliders have been touched */
    @State var touchedAudio: Bool = false
    @State var touchedVideo: Bool = false
    @State var touchedOverall: Bool = false

    func saveAndContinue() {
        /* save data */
        self.participantData.questionnaireData[self.participantData
                                                .questionnaireIndex].audioQuality = self.audioQuality
        self.participantData.questionnaireData[self.participantData
                                                .questionnaireIndex].videoQuality = self.videoQuality
        self.participantData.questionnaireData[self.participantData
                                                .questionnaireIndex].overallQuality = self.overallQuality

        /* open next view */
        self.showQuestionnaireEmotion = true

        /* close this view */
        dismiss()
    }

    var body: some View {
        VStack {

            Spacer()


            VStack {
                Text("Gesamtqualität")
                VStack {
                    /* slider for video quality */
                    Slider(value: self.$overallQuality, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Quality_overallQualitySlider")

                        /* slider was touched */
                        self.touchedOverall = true
                    }
                        .accentColor(Color(UIColor.systemGray5))
                        .padding([.leading, .trailing], -7.5)
                        .zIndex(1)
                    /* image mos scale */
                    Image("Skala_mit_Overflow_DE")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, -20)
                }
            }
            .padding()


            VStack {
                Text("Audioqualität")
                VStack {
                    /* slider for video quality */
                    Slider(value: self.$audioQuality, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Quality_audioQualitySlider")
                        
                        /* slider was touched */
                        self.touchedAudio = true
                    }
                        .accentColor(Color(UIColor.systemGray5))
                        .padding([.leading, .trailing], -7.5)
                        .zIndex(1)
                    /* image mos scale */
                    Image("Skala_mit_Overflow_DE")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, -20)
                }
            }
            .padding()



            VStack {
                Text("Videoqualität")
                VStack {
                    /* slider for video quality */
                    Slider(value: self.$videoQuality, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Quality_videoQualitySlider")
                        
                        /* slider was touched */
                        self.touchedVideo = true
                    }
                        .accentColor(Color(UIColor.systemGray5))
                        .padding([.leading, .trailing], -7.5)
                        .zIndex(1)
                    /* image mos scale */
                    Image("Skala_mit_Overflow_DE")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, -20)
                }
            }
            .padding()


            Spacer()

            /* "continue" button */
            Button(action: {

                /* recognize tap gesture on this element */
                self.participantData.addTouchSample(locationTap: "Quality_continueButton")

                /* check if all questions were answered */
                if self.touchedAudio == false || self.touchedVideo == false || self.touchedOverall == false {
                    self.showAlert = true
                } else {
                    self.saveAndContinue()
                }

            }) {
                ButtonTextFullWidth(text: "Weiter")
            }
            .alert(isPresented: self.$showAlert) {
                Alert(
                    title: Text("Du hast nicht alle Fragen beantwortet").font(.title),
                    message: Text("Bitte beantworte wenn möglich alle Fragen").font(.title),
                    primaryButton: .cancel(Text("Fragen beantworten")) {
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Quality_Alert_cancelButton")
                    },
                    secondaryButton: .destructive(Text("Trotzdem fortfahren")) {
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Quality_Alert_continueButton")

                        /* change value from 0 to -999 to indicate that user did not make any input */
                        if self.touchedAudio == false {
                            self.audioQuality = -999
                        }
                        if self.touchedVideo == false {
                            self.videoQuality = -999
                        }
                        if self.touchedOverall == false {
                            self.overallQuality = -999
                        }

                        /* go next screen even if not all questions were answered */
                        self.saveAndContinue()
                    }
                )
            }

        }
        /* recognize tap gesture on elements in foreground */
        .onTapGesture {
            self.participantData.addTouchSample(locationTap: "Quality_Screen")
        }
        /* recognizes touch input in the background */
        .background() {
            Color.clear
                /* necessary for clear color to detect touch input */
                .contentShape(Rectangle())
                /* recognize tap gesture */
                .onTapGesture {
                    self.participantData.addTouchSample(locationTap: "Quality_Screen")
                }
        }

    }
}

struct QuestionnaireQuality_Previews: PreviewProvider {
    @State static var showQuestionnaireEmotion: Bool = false

    static var previews: some View {
        QuestionnaireQuality(
            showQuestionnaireEmotion: $showQuestionnaireEmotion
        )
            .environmentObject(
                ParticipantData(
                    participantId: "XYZ",
                    videoNames: ["Story1_Part1_Q1"],
                    videoQuestions: ["what's up?"]
                )
            )
    }
}
