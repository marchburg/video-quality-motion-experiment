//
//  DataFactory.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 08.02.22.
//

import Foundation

/* contains the information about the order of the videos and their quality level, as well as the questions following each video for one person in the experiment */
struct ParticipantSpecification: Hashable {
    
    /* unique id */
    var pid: String = ""
    
    /* contain the numbers of the stories 1-4 */
    var pc_story_1: String = ""
    var pc_story_2: String = ""
    var pc_story_3: String = ""
    var mobile_story: String = ""

    /* contains the quality levels 1-4 for the 10 parts for each of the four stories */
    var qualities: [[String]] = [[""],[""],[""],[""]]
    
    /* contains the question types "accoustic"/"visual" for each part of the four videos */
    var types: [[String]] = [[],[],[],[]]
    
    /* contains the questions for each part of the four videos */
    var questions: [[String]] = [[],[],[],[]]
    
    init(raw: [String]) {
        pid = raw[0]
        pc_story_1 = raw[1]
        pc_story_2 = raw[2]
        pc_story_3 = raw[3]
        mobile_story = raw[4]

        qualities[0] = Array(raw[5...14])
        qualities[1] = Array(raw[15...24])
        qualities[2] = Array(raw[25...34])
        qualities[3] = Array(raw[35...44])
        
        /* create array with question types and texts for all stories and parts */
        let typeAndText = Array(raw[45...124])
        
        /* distribute the question types and texts */
        for (index, element) in typeAndText.enumerated() {
            /* which of the four stories does the element belong to? */
            let storyIndex = Int(index / 20)
            
            /* even indices are types */
            if index % 2 == 0 {
                types[storyIndex].append(element)
            } else {
                questions[storyIndex].append(element)
            }
        }
        
    }
    
    /* returns an array with names of videos intended for this participant */
    func getVideoNamesMobileStory() -> [String] {
        
        /* create empty array */
        var videoNames: [String] = []
        
        /* the number of the story 1,2,3,4 */
        let storyNr = self.mobile_story
        
        /* create the name for videos e. g. "Story1_Part3_Q2" */
        for part in 1...10 {
            /* get quality level for this part for story intended for this participant */
            let qualityLevel: String = qualities[(Int(storyNr) ?? 1) - 1][part - 1]
            /* add name of video */
            videoNames.append("Story\(storyNr)_Part\(part)_\(qualityLevel)")
        }
        
        return videoNames
    }
    
    /* returns an array with questions coming after each video intended for this participant */
    func getVideoQuestionsMobileStory() -> [String] {
        /* the number of the story 1,2,3,4 */
        let storyNr = self.mobile_story
        return self.questions[(Int(storyNr) ?? 1) - 1]
    }
    
    
    
}






