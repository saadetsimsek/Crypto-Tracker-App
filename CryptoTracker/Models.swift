//
//  Models.swift
//  CryptoTracker
//
//  Created by Saadet Şimşek on 21/08/2024.
//

import Foundation

struct Crypto: Codable {
    let asset_id: String
    let name: String?
    let price_usd: Double?
    let id_icon: String?
}
