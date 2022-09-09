//
//  QuestionnaireAdditional_1.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 28.02.22.
//

import SwiftUI

struct QuestionnaireAdditional_1: View {

    /* used to close this view when shown as sheet / fullScreenCover */
    @Environment(\.dismiss) var dismiss // iOS15+

    /* participant data */
    @EnvironmentObject var participantData: ParticipantData

    /* controls if next view with additional questions is shown */
    @Binding var showQuestionnaireAdditional_2: Bool

    /* controls if alert is shown that questions have not been answered yet */
    @State var showAlert: Bool =  false

    /* hold the variables set in sliders */
    @State var mentalDemand: Double = 0
    @State var effort: Double = 0
    @State var temporalDemand: Double = 0

    /* control if Sliders have been touched */
    @State var touchedMentalDemand: Bool = false
    @State var touchedEffort: Bool = false
    @State var touchedTemporalDemand: Bool = false

    /* save values in participant data and continue to next view */
    func saveAndContinue() {

        /* save data */
        self.participantData.questionnaireData[self.participantData
                                                .questionnaireIndex].mentalDemand = self.mentalDemand
        self.participantData.questionnaireData[self.participantData
                                                .questionnaireIndex].effort = self.effort
        self.participantData.questionnaireData[self.participantData
                                                .questionnaireIndex].temporalDemand = self.temporalDemand

        /* show next view */
        self.showQuestionnaireAdditional_2 = true

        /* close this view */
        dismiss()
    }

    var body: some View {
        VStack {

            Spacer()

            /* mental demand */
            VStack {
                Text("Wie viel GEISTIGE ANFORDERUNG war bei der Informationsaufnahme und -verarbeitung erforderlich?")
                VStack {
                    Slider(value: self.$mentalDemand, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Additional1_mentalDemandSlider")
                        
                        self.touchedMentalDemand = true
                    }
                    HStack {
                        Text("gering")
                        Spacer()
                        Text("hoch")
                    }
                }
            }
            .padding()

            Spacer()

            /* effort */
            VStack {
                Text("Wie HART musstest du ARBEITEN, um deinen Grad an Aufgabenerfüllung zu erreichen?")
                VStack {
                    Slider(value: self.$effort, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Additional1_effortSlider")
                        
                        self.touchedEffort = true
                    }
                    HStack {
                        Text("gering")
                        Spacer()
                        Text("hoch")
                    }
                }
            }
            .padding()

            Spacer()


            /* temporal demand */
            VStack {
                Text("Wie EILIG oder GEHETZT war das Tempo der Aufgabe?")
                VStack {
                    Slider(value: self.$temporalDemand, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Additional1_temporalDemandSlider")
                        
                        self.touchedTemporalDemand = true
                    }
                    HStack {
                        Text("gering")
                        Spacer()
                        Text("hoch")
                    }
                }
            }
            .padding()


            Spacer()

            /* "continue" button */
            Button(action: {
                
                /* recognize tap gesture on this element */
                self.participantData.addTouchSample(locationTap: "Additional1_continueButton")

                /* check if user interacted with the Sliders */
                if self.touchedMentalDemand == false || self.touchedEffort == false || self.touchedTemporalDemand == false {
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
                        self.participantData.addTouchSample(locationTap: "AdditionalQuestions1_Alert_cancelButton")
                        
                    },
                    secondaryButton: .destructive(Text("Trotzdem fortfahren")) {
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "AdditionalQuestions1_Alert_continueButton")

                        if self.touchedMentalDemand == false {
                            self.mentalDemand = -999
                        }
                        if self.touchedEffort == false {
                            self.effort = -999
                        }
                        if self.touchedTemporalDemand == false {
                            self.temporalDemand = -999
                        }
                        /* go next screen even if not all questions were answered */
                        self.saveAndContinue()
                    }
                )
            }

        }
        /* recognize tap gesture on elements in foreground */
        .onTapGesture {
            self.participantData.addTouchSample(locationTap: "AdditionalQuestions1_Screen")
        }
        /* recognizes touch input in the background */
        .background() {
            Color.clear
                /* necessary for clear color to detect touch input */
                .contentShape(Rectangle())
                /* recognize tap gesture */
                .onTapGesture {
                    self.participantData.addTouchSample(locationTap: "AdditionalQuestions1_Screen")
                }
        }
        
    }
}

struct QuestionnaireAdditional_1_Previews: PreviewProvider {

    @State static var showQuestionnaireAdditional_2: Bool = false

    static var previews: some View {
        QuestionnaireAdditional_1(showQuestionnaireAdditional_2: $showQuestionnaireAdditional_2)
            .environmentObject(
                ParticipantData(
                    participantId: "XYZ",
                    videoNames: ["Story1_Part1_Q1"],
                    videoQuestions: ["what's up?"]
                )
            )
    }
}
