//
//  Transaction.swift
//  rapyd
//
//  Created by Roland Michelberger on 08.06.21.
//

import Foundation

struct Transaction: Codable, Identifiable {
    let id: String
    let currency: String
    let amount: Double
    let ewallet_id: String
    let type: TransactionType
    let balance_type: BalanceType
    let created_at: Double
    let status: Status
    let reason: String
    
    enum BalanceType: String, Codable {
        case available_balance, on_hold_balance, received_balance, reserve_balance
    }

    enum Status: String, Codable {
        case CLOSED, ACTIVE
    }

}

extension Transaction {
    
    var formattedAmount: String {
        if currency.isEmpty {
            return "-"
        }
        let money = Money(amount: amount, currency: currency)
        return money.fomattedString
    }
    
    var formattedDate: String {
        let date = Date(timeIntervalSince1970: created_at)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: date)
    }
}

enum TransactionType: String, Codable {
    case add_funds, remove_funds, p2p_transfer
}
