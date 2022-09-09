//
//  ParticipantData.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 04.02.22.
//

import Foundation

/* stores information gathered on one participant during experiment */
class ParticipantData: ObservableObject {
    
    /* id of the participant */
    let participantId: String
    
    /* a list of videos which the participant will see one after the other */
    var videoNames: [String]
    
    /* questions which are presented after each video */
    var videoQuestions: [String]
    
    /* answers from questionnaires filled out by participant after each video */
    @Published var questionnaireData: [QuestionnaireSample] = []
    
    /* motion and video data */
    var motionVideoData: [DataSample] = []
    
    /* touch input data */
    var touchData: [TouchSample] = []
    
    /* the index of the QuestionnaireSample currently used in questionnaireData */
    var questionnaireIndex: Int = 0
    
    init(participantId: String, videoNames: [String], videoQuestions: [String]) {
        self.participantId = participantId
        self.videoNames = videoNames
        self.videoQuestions = videoQuestions
        
        /* create a questionnaire sample for each video shown to participant */
        self.questionnaireData = createQuestionnaireSamples()
    }
    
    /* create and add a touch sample */
    func addTouchSample(locationTap: String) {
        print("tap gesture recognized")
        let touchSample = TouchSample(timeStampTap: formattedDateStringNow(), locationTap: locationTap)
        self.touchData.append(touchSample)
    }
    
    /* creates a questionnaire sample for every video that will be shown to participant */
    func createQuestionnaireSamples() -> [QuestionnaireSample] {
        var questionnaireSamples: [QuestionnaireSample] = []
        for videoName in self.videoNames {
            questionnaireSamples.append(QuestionnaireSample(participantId: self.participantId, videoId: videoName))
        }
        return questionnaireSamples
    }
    
    /* get current question on video content */
    func getCurrentQuestionVideoContent() -> String {
        
//        if self.questionnaireIndex < videoNames.count - 1 {
            return self.videoQuestions[questionnaireIndex]
//        }
//        else {
//            return "error: no question available"
//        }
    }
   
}


