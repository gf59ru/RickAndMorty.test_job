//
//  Date.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import Foundation

extension DateFormatter {

    static var serverDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        // 2018-01-10T18:20:41.703Z
        return formatter
    }
}
