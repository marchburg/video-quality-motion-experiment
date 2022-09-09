//
//  QuestionnaireSample.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 04.02.22.
//

import Foundation

/* contains the answers from questionnaires after each video */
struct QuestionnaireSample: Codable {
    
    let participantId: String
    
    let videoId: String
    
    var audioQuality: Double = -999
    var videoQuality: Double = -999
    var overallQuality: Double = -999
    
    var valence: Double = -999
    var arousal: Double = -999
    
    var mentalDemand: Double = -999
    var effort: Double = -999
    var temporalDemand: Double = -999
    var performance: Double = -999
    var frustration: Double = -999
    var connection: Double = -999
    
    var storyEnjoy: Double = -999
    var personVivid: Double = -999
    var personLikable: Double = -999
    
    func toString() -> String {
        let jsonEncoder = JSONEncoder()
    
        do {
            let encodeSample = try jsonEncoder.encode(self)
            let endcodeStringSample = String(data: encodeSample, encoding: .utf8)!
            return endcodeStringSample
        } catch {
            print(error.localizedDescription)
            return "error while encoding motionSample to String"
        }
    }
    
}
