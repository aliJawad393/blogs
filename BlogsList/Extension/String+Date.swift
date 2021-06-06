//
//  String+Date.swift
//  BlogsList
//
//  Created by Ali Jawad on 30/05/2021.
//

import Foundation

extension String {
    func formatDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: self) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "hh a, MMM dd, yyyy" //11 AM, May 29, 2021
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
