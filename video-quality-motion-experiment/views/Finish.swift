//
//  Finish.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 25.01.22.
//

import SwiftUI
import UIKit


struct Finish: View {
    
    /* participant data */
    @EnvironmentObject var participantData: ParticipantData
    
    /* used to close this view when shown as sheet / fullScreenCover */
    @Environment(\.dismiss) var dismiss // iOS15+

    /* controls if view to export data is shown */
    @Binding var showExport: Bool
    
    /* controls if alert is shown that questions have not been answered yet */
    @State var showAlert: Bool =  false
    
    /* hold the variables set in sliders */
    @State var storyEnjoy: Double = 0
    @State var personVivid: Double = 0
    @State var personLikable: Double = 0
    
    /* control if Sliders have been touched */
    @State var touchedStoryEnjoy: Bool = false
    @State var touchedPersonVivid: Bool = false
    @State var touchedPersonLikable: Bool = false
    
    func saveAndContinue() {
        
        /* save data */
        self.participantData.questionnaireData[0].storyEnjoy = self.storyEnjoy
        self.participantData.questionnaireData[0].personVivid = self.personVivid
        self.participantData.questionnaireData[0].personLikable = self.personLikable
        
        /* close this view */
        dismiss()
        
        /* show export view */
        self.showExport = true
    }
    
    var body: some View {
 
        VStack {
            
            Spacer()
            
            /* story enjoy */
            VStack {
                Text("Wie hat dir die Geschichte gefallen?")
                VStack {
                    Slider(value: self.$storyEnjoy, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Finish_storyEnjoySlider")
                        
                        self.touchedStoryEnjoy = true
                    }
                    HStack {
                        Text("schlecht / langweilig / negativ")
                        Spacer()
                        Text("gut / interessant / positiv")
                    }
                        //.accentColor(Color(UIColor.systemGray5))
                }
            }
            .padding()
            
            Spacer()
            
            /* frustration */
            VStack {
                Text("Wie LEBHAFT hat die Person die Geschichte erzählt?")
                VStack {
                    Slider(value: self.$personVivid, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Finish_frustrationSlider")
                        
                        self.touchedPersonVivid = true
                    }
                    HStack {
                        Text("gelangweilt / uninteressiert / negativ")
                        Spacer()
                        Text("begeistert / mitreißend / positiv")
                    }
                        //.accentColor(Color(UIColor.systemGray5))
                }
            }
            .padding()
        
            Spacer()
            
            
            /* connection */
            VStack {
                Text("Wie sympathisch fandest du die Person im Video?")
                VStack {
                    Slider(value: self.$personLikable, in: -1...1) { editing in
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Finish_connectionSlider")
                        
                        self.touchedPersonLikable = true
                    }
                    HStack {
                        Text("unsympathisch / negativ")
                        Spacer()
                        Text("sympathisch / positiv")
                    }
                        //.accentColor(Color(UIColor.systemGray5))
                }
            }
            .padding()
            
            
            Spacer()
            
            /* "continue" button */
            Button(action: {
                
                /* recognize tap gesture on this element */
                self.participantData.addTouchSample(locationTap: "Finish_continueButton")
                
                /* check if user interacted with the Sliders */
                if self.touchedStoryEnjoy == false || self.touchedPersonVivid == false || self.touchedPersonLikable == false {
                    self.showAlert = true
                } else {
                    self.saveAndContinue()
                }
                
            }) {
                ButtonTextFullWidth(text: "Weiter")
            }
            .alert(isPresented: self.$showAlert) {
                Alert(
                    title: Text("Sie haben nicht alle Fragen beantwortet").font(.title),
                    message: Text("Bitte beantworten Sie wenn möglich alle Fragen").font(.title),
                    primaryButton: .cancel(Text("Fragen beantworten")) {
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Finish_Alert_cancelButton")
                        
                    } ,
                    secondaryButton: .destructive(Text("Trotzdem fortfahren")) {
                        
                        /* recognize tap gesture on this element */
                        self.participantData.addTouchSample(locationTap: "Finish_Alert_continueButton")
                        
                        if self.touchedStoryEnjoy == false {
                            self.storyEnjoy = -999
                        }
                        if self.touchedPersonVivid == false {
                            self.personVivid = -999
                        }
                        if self.touchedPersonLikable == false {
                            self.personLikable = -999
                        }
                        /* go next screen even if not all questions were answered */
                        self.saveAndContinue()
                    }
                )
            }

        }
        /* recognize tap gesture on elements in foreground */
        .onTapGesture {
            self.participantData.addTouchSample(locationTap: "Finish_Screen")
        }
        /* recognizes touch input in the background */
        .background() {
            Color.clear
                /* necessary for clear color to detect touch input */
                .contentShape(Rectangle())
                /* recognize tap gesture */
                .onTapGesture {
                    self.participantData.addTouchSample(locationTap: "Finish_Screen")
                }
        }
        
    }
}

struct Finish_Previews: PreviewProvider {
    @State static var showExport: Bool = false
    static var previews: some View {
        Finish(showExport: $showExport)
            .environmentObject(
                ParticipantData(
                    participantId: "XYZ",
                    videoNames: ["Story1_Part1_Q1"],
                    videoQuestions: ["what's up?"]
                )
            )
    }
}
