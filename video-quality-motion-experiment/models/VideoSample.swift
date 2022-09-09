//
//  VideoSample.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 17.12.21.
//

import Foundation

struct VideoSample: Codable {
    
    /* timestamp when this video sample was created */
    var timeStampPhone: String
    
    /* a number that is continuously increased */
    var sampleCount: Int
    
    /* id of the video stimulus */
    var videoID: String
    
    
    /* the current time of the video in seconds */
    var currentTimeVideo: String
    
    
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
