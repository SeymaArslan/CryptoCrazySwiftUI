//
//  CryptoCurrency.swift
//  CryptoCrazySwiftUI
//
//  Created by Seyma on 23.10.2023.
//

import UIKit

struct CryptoCurrency: Hashable, Decodable, Identifiable {
    let id = UUID()  // oluşacak her CryptoCurrency nesnesi için bir id oluşmalı
    let currency: String
    let price: String
    
    // CodingKey protocol bir arayüzdür enumların/keylerin hangi isimde geleceğini belirtebileceğimiz bir yapıdır.
    private enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case price = "price"
    }
}
