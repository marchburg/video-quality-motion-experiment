//
//  DataSample.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 18.01.22.
//

import Foundation

struct DataSample: Codable {
    
    let participantId: String
    
    let motionSample: MotionSample
    
    let videoSample: VideoSample
    
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
