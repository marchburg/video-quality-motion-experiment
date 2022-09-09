//
//  csvHelper.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 08.02.22.
//

import Foundation

func loadCSV(from csvName: String) -> [ParticipantSpecification] {

    var csvToStruct = [ParticipantSpecification]()

    /* locate the csv file */
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
        return []
    }

    /* convert the contents of the  file into one very long string */
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    } catch {
        print(error)
        return []
    }

    /* split the  string into an array of "rows" of data. Each row is a string */
    var rows = data.components(separatedBy: "\n")

    /* remove header row */
    rows.removeFirst()

    /* remove last empty row */
    rows.removeLast()


    /* loop over each row and split into columns */
    for row in rows {

        /* create array of row elements */
        let csvColumns = row.components(separatedBy: ";")

        /* create a ParticipantSpecification object from each row */
        let participantSpecification = ParticipantSpecification.init(raw: csvColumns)

        /* add new object to array of participant specifications */
        csvToStruct.append(participantSpecification)
    }

    return csvToStruct
}
