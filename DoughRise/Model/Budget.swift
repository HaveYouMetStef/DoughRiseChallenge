//
//  Budget.swift
//  DoughRise
//
//  Created by Stef Castillo on 5/16/23.
//

import Foundation

struct Budget {
    let id: UUID
    var amount: Double
}

struct Transaction: Equatable {
    let id: UUID
    var amount: Double
    let date: Date
    let type: String
    let totalAmount: Double
}
