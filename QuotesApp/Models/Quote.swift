//
//  Quote.swift
//  QuotesApp
//
//  Created by Claire Coding Account on 2022-02-23.
//

import Foundation

struct Quote: Decodable, Hashable {
    let quoteText: String
    let quoteAuthor: String
    let quoteLink: String
}
