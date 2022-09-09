//
//  Export.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 25.01.22.
//

import SwiftUI
import UIKit

enum ParticipantDataType {
    case questionnaireData
    case motionVideoData
    case touchData
}

struct Export: View {
    
    /* controls if view to select a new participant id for next experiment run is shown */
    @Binding var selectNewParticipantId: Bool
    
    /* participant data */
    @EnvironmentObject var participantData: ParticipantData
    
    /* controls if share menu for questionnaire data is shown */
    @State private var showShare_QuestionnaireData: Bool = false
    @State private var showShare_MotionVideoData: Bool = false
    @State private var showShare_TouchData: Bool = false
    
    /* greyed out continue button before exporting data */
    @State var disabledContinueButton: Bool = true
    
    
    /* create heading for csv file with motion and video data */
    func getHeadingMotionVideo() -> String {
        var csvHeadings = ""
        
        csvHeadings.append("participantId, ")
        
        let mirrorVideo = Mirror(reflecting: self.participantData.motionVideoData[0].videoSample)
        
        for (_, child) in mirrorVideo.children.enumerated() {
            csvHeadings += "\(child.label ?? "StringNotAvailable")"
            csvHeadings += ", "
        }
        
        let mirrorMotion = Mirror(reflecting: self.participantData.motionVideoData[0].motionSample)
        
        for (idx, child) in mirrorMotion.children.enumerated() {
            csvHeadings += "\(child.label ?? "StringNotAvailable")"
            if idx == mirrorMotion.children.count-1 {
                csvHeadings += "\n"
            } else {
                csvHeadings += ", "
            }
        }
        
        return csvHeadings
    }
    
    /* create file content for csv file with motion and video data */
    func getFileContentMotionVideo() -> String {
        
        var csvFile = ""
        
        for dataSample in participantData.motionVideoData {
            
            var row = ""
            
            /* participant id */
            row += "\(dataSample.participantId), "
            
            /* video data */
            let mirrorVideo = Mirror(reflecting: dataSample.videoSample)
            for (_, child) in mirrorVideo.children.enumerated() {
                row += "\(child.value), "
            }
            
            /* motion data */
            let mirrorMotion = Mirror(reflecting: dataSample.motionSample)
            for (idx, child) in mirrorMotion.children.enumerated() {
                row += "\(child.value)"
                if idx == mirrorMotion.children.count-1 {
                    row += "\n"
                } else {
                    row += ", "
                }
            }
            
            csvFile += row
            
        }
        
        return csvFile
    }
    
    /* create heading for csv file with questionnaire data */
    func getHeadingQuestionnaire() -> String {
        var csvHeadings = ""
        
        /* mirror a QuestionnaireData object to get loop over names of properties */
        let mirror = Mirror(reflecting: self.participantData.questionnaireData[0])
        for (idx, child) in mirror.children.enumerated() {
            csvHeadings += "\(child.label ?? "StringNotAvailable")"
            if idx == mirror.children.count-1 {
                csvHeadings += "\n"
            } else {
                csvHeadings += ", "
            }
        }
        
        return csvHeadings
    }
    
    /* create file content for csv file with questionnaire data */
    func getFileContentQuestionnaire() -> String {
        
        var csvFile = ""
        
        /* create file content */
        for questionnaireSample in participantData.questionnaireData {
            let mirror = Mirror(reflecting: questionnaireSample)
            var row = ""
            for (idx, child) in mirror.children.enumerated() {
                row += "\(child.value)"
                if idx == mirror.children.count-1 {
                    row += "\n"
                } else {
                    row += ", "
                }
            }
            /* append row with questionnaire answers for one video */
            csvFile += row
        }
        
        return csvFile
    }
    
    /* create heading for csv file with touch data */
    func getHeadingTouch() -> String {
        var csvHeadings = ""
        
        /* mirror a TouchSample object to get loop over names of properties */
        let mirror = Mirror(reflecting: self.participantData.touchData[0])
        for (idx, child) in mirror.children.enumerated() {
            csvHeadings += "\(child.label ?? "StringNotAvailable")"
            if idx == mirror.children.count-1 {
                csvHeadings += "\n"
            } else {
                csvHeadings += ", "
            }
        }
        
        return csvHeadings
    }
    
    /* create file content for csv file with touch data */
    func getFileContentTouch() -> String {
        
        var csvFile = ""
        
        /* create file content */
        for touchSample in participantData.touchData {
            let mirror = Mirror(reflecting: touchSample)
            var row = ""
            for (idx, child) in mirror.children.enumerated() {
                row += "\(child.value)"
                if idx == mirror.children.count-1 {
                    row += "\n"
                } else {
                    row += ", "
                }
            }
            /* append row */
            csvFile += row
        }
        
        return csvFile
    }
    
    /* create a csv file with questionnaire, motion/vision or touch data */
    func getShareResults(dType: ParticipantDataType) -> [Any] {
        
        var csvString = ""
        
        /* create headings for columns */
        var csvHeadings = ""

        switch dType {
        case .questionnaireData:
            csvHeadings = self.getHeadingQuestionnaire()
        case .motionVideoData:
            csvHeadings = self.getHeadingMotionVideo()
        case .touchData:
            csvHeadings = self.getHeadingTouch()
        }
        
        // debug
        print("csvHeadings: \(csvHeadings)")
        
        /* append headings */
        csvString += csvHeadings
        
        var csvFileContent = ""
        
        switch dType {
        case .questionnaireData:
            csvFileContent = self.getFileContentQuestionnaire()
        case .motionVideoData:
            csvFileContent = self.getFileContentMotionVideo()
        case .touchData:
            csvFileContent = self.getFileContentTouch()
        }
        
        /* append file content */
        csvString += csvFileContent
        
        // debug
        print("csvString:")
        print(csvString)

        /* create filename */
        let date = Date()
        let calendar = Calendar.current
        let dateString = "\(calendar.component(.year, from: date))-\(calendar.component(.month, from: date))-\(calendar.component(.day, from: date))_\(calendar.component(.hour, from: date))-\(calendar.component(.minute, from: date))"
        let csvFilename = "PN\(self.participantData.participantId)_\(dateString)_videoQualityMotionExperiment_\(dType).csv"

        // write file & open share view
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(csvFilename)

            do {
                try csvString.write(to: fileURL, atomically: false, encoding: .utf8)

                let objectsToShare = [fileURL]
                
                return objectsToShare
            }
            catch {
                print("error while writing file")
            }
        }
        return []
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Vielen Dank")
                .font(.title)
                .bold()
                .padding()
           
            Text("Bitte geben Sie dieses Gerät nun der Versuchsleiter:in")
                .font(.title)
                .bold()
                .padding()

            
            /* open share menu with sheet for questionnaire data */
            Button(action: {
                self.showShare_QuestionnaireData = true
                self.disabledContinueButton = false
            }) {
                VStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Export Questionnaire Data")
                }
                    .padding()
            }
            .sheet(isPresented: $showShare_QuestionnaireData, onDismiss: {
                print("Dismiss")
            }, content: {
                ActivityViewController(activityItems: // self.getShareResults_QuestionnaireData()
                                       self.getShareResults(dType: .questionnaireData)
                )
            })
            
            
            
            if !self.participantData.motionVideoData.isEmpty {
                /* open share menu with sheet for motion and video data */
                Button(action: {
                    if !self.participantData.motionVideoData.isEmpty {
                        self.showShare_MotionVideoData = true
                        self.disabledContinueButton = false
                    } else {
                        print("no motion and video data available")
                    }
                }) {
                    VStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export Motion and Video Data")
                    }
                        .padding()
                }
                .sheet(isPresented: $showShare_MotionVideoData, onDismiss: {
                    print("Dismiss")
                }, content: {
                    ActivityViewController(activityItems: self.getShareResults(dType: .motionVideoData)
                    )
                })
            } else {
                Text("no motion and video data available")
            }
            
            if !self.participantData.touchData.isEmpty {
                /* open share menu with sheet for touch data */
                Button(action: {
                    if !self.participantData.touchData.isEmpty {
                        self.showShare_TouchData = true
                        self.disabledContinueButton = false
                    } else {
                        print("no touch data available")
                    }
                }) {
                    VStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export Touch Data")
                    }
                        .padding()
                }
                .sheet(isPresented: $showShare_TouchData, onDismiss: {
                    print("Dismiss")
                }, content: {
                    ActivityViewController(activityItems: self.getShareResults(dType: .touchData)
                    )
                })
            } else {
                Text("no touch data available")
            }

            
            Spacer()
            
            /* button to finish experiment */
            Button(action: {
                /* show view to enter participant id */
                self.selectNewParticipantId = true
            }) {
                ButtonTextFullWidth(text: "Fertig")
            }
            .disabled(self.disabledContinueButton)
            
        }

    }
}

struct Export_Previews: PreviewProvider {
    @State static var selectNewParticipantId: Bool = false
    static var previews: some View {
        Export(selectNewParticipantId: $selectNewParticipantId)
            .environmentObject(
                ParticipantData(
                    participantId: "XYZ",
                    videoNames: ["Story1_Part1_Q1"],
                    videoQuestions: ["what's up?"]
                )
            )
    }
}

