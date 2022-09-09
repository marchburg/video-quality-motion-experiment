//
//  QuestionnaireAdditional_2.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 28.02.22.
//

import SwiftUI

struct QuestionnaireAdditional_2: View {

    /* participant data */
    @EnvironmentObject var participantData: ParticipantData

    /* used to close this view when shown as sheet / fullScreenCover */
    @Environment(\.dismiss) var dismiss // iOS15+
    
    @Binding var currentVideoIndex: Int

    /* if true: screen with start button is shown */
    @Binding var showAreYouReady: Bool

    /* if true: the last video has been shown, this is final questionnaire */
    @Binding var finalRoundQuestionnaires: Bool

    /* indicate to view StimulusPresentation that questionnaire was finished */
    @Binding var finalQuestionnairesFinished: Bool

    /* controls if alert is shown that questions have not been answered yet */
    @State var showAlert: Bool =  false

    /* hold the variables set in sliders */
    @State var performance: Double = 0
    @State var frustration: Double = 0
    @State var connection: Double = 0

    /* control if Sliders have been touched */
    @State var touchedPerformance: Bool = false
    @State var touchedFrustration: Bool = false
    @State var touchedConnection: Bool = false
    
    
    /* increments index of current video if there is a next video available */
    func updateCurrentVideoIndex() {
        let amountVideos = self.participantData.videoNames.count
        if self.currentVideoIndex < amountVideos - 1 {
            self.currentVideoIndex = self.currentVideoIndex + 1
        }
    }

    func saveAndContinue() {

        /* save data */
        self.participantData.questionnaireData[self.participantData
                                                .questionnaireIndex].performance = self.performance
        self.participantData.questionnaireData[self.participantData
                                                .questionnaireIndex].frustration = self.frustration
        self.participantData.questionnaireData[self.participantData
                                                .questionnaireIndex].connection = self.connection
        
        /* update index of current video */
        self.updateCurrentVideoIndex()

        /* update index of current questionnaire */
        self.participantData.questionnaireIndex += 1

        /* close this view */
        dismiss()

        if self.finalRoundQuestionnaires {
            /* indicate that last questionnaire is finished */
            self.finalQuestionnairesFinished = true
        } else {
            /* show view to start next video */
            self.showAreYouReady = true
        }
    }

    var body: some View {

        VStack {

            Spacer()

            /* performance */
            VStack {
                Text("Wie ERFOLGREICH und ZUFRIEDEN hast du deiner Meinung nach die Ziele der Aufgabe erreicht?")
                VStack {
                    Slider(value: self.$performance, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "AdditionalQuestions2_performanceSlider")
                        
                        self.touchedPerformance = true
                    }
                    HStack {
                        Text("gut")
                        Spacer()
                        Text("schlecht")
                    }
                        //.accentColor(Color(UIColor.systemGray5))
                }
            }
            .padding()

            Spacer()

            /* frustration */
            VStack {
                Text("Wie entmutigt, IRRITIERT, gestresst und VERÄRGERT (versus entspannt und zufrieden) fühlst du dich während der Aufgabe?")
                VStack {
                    Slider(value: self.$frustration, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "AdditionalQuestions2_frustrationSlider")
                        
                        self.touchedFrustration = true
                    }
                    HStack {
                        Text("gering")
                        Spacer()
                        Text("hoch")
                    }
                        //.accentColor(Color(UIColor.systemGray5))
                }
            }
            .padding()

            Spacer()


            /* connection */
            VStack {
                Text("Wie gehst du mit der Verbindung um?")
                VStack {
                    Slider(value: self.$connection, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "AdditionalQuestions2_connectionSlider")
                        
                        self.touchedConnection = true
                    }
                    HStack {
                        Text("ABBRECHEN & Anruf wiederholen")
                        Spacer()
                        Text("Anruf FORTFÜHREN")
                    }
                        //.accentColor(Color(UIColor.systemGray5))
                }
            }
            .padding()


            Spacer()

            /* "continue" button */
            Button(action: {
                
                /* recognize tap gesture on this element */
                self.participantData.addTouchSample(locationTap: "AdditionalQuestions2_continueButton")

                /* check if user interacted with the Sliders */
                if self.touchedPerformance == false || self.touchedFrustration == false || self.touchedConnection == false {
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
                        self.participantData.addTouchSample(locationTap: "AdditionalQuestions2_Alert_cancelButton")
                        
                    },
                    secondaryButton: .destructive(Text("Trotzdem fortfahren")) {
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "AdditionalQuestions2_Alert_continueButton")

                        if self.touchedPerformance == false {
                            self.performance = -999
                        }
                        if self.touchedFrustration == false {
                            self.frustration = -999
                        }
                        if self.touchedConnection == false {
                            self.connection = -999
                        }
                        /* go next screen even if not all questions were answered */
                        self.saveAndContinue()
                    }
                )
            }

        }
        /* recognize tap gesture on elements in foreground */
        .onTapGesture {
            self.participantData.addTouchSample(locationTap: "AdditionalQuestions2_Screen")
        }
        /* recognizes touch input in the background */
        .background() {
            Color.clear
                /* necessary for clear color to detect touch input */
                .contentShape(Rectangle())
                /* recognize tap gesture */
                .onTapGesture {
                    self.participantData.addTouchSample(locationTap: "AdditionalQuestions2_Screen")
                }
        }

    }
}

struct QuestionnaireAdditional_2_Previews: PreviewProvider {

    @State static var showAreYouReady: Bool = false
    @State static var finalRoundQuestionnaires: Bool = false
    @State static var finalQuestionnairesFinished: Bool = false
    @State static var currentVideoIndex: Int = 4

    static var previews: some View {
        QuestionnaireAdditional_2(
            currentVideoIndex: $currentVideoIndex,
            showAreYouReady: $showAreYouReady,
            finalRoundQuestionnaires: $finalRoundQuestionnaires,
            finalQuestionnairesFinished: $finalQuestionnairesFinished
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
