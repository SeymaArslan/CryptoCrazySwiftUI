//
//  Webservice.swift
//  CryptoCrazySwiftUI
//
//  Created by Seyma on 23.10.2023.
// 

import Foundation

class Webservice {
    func downloadCurrencies(url: URL, completion: @escaping(Result<[CryptoCurrency]?,DownloaderError>) -> Void) {
        // URLSession.shared.dataTask otomatik olarak background' ta çalışıyor UI işlemlerinde verileri kullanacağımız zaman DispatchQeueue.main ile main' de çalıştığımızı söylememiz gerekiyordu.. burada escaping iş tamamlanınca bana şunu ver der peki ne vereceğiz Result içinde <[CryptoCurrency]?,DownloaderError> yani URLSession çalışması bitince ya nesne dizisi ya hata verecek ve her ikisini de inceleyebileceğiz.
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.badURL))
            }
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            guard let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data) else {
                return completion(.failure(.dataParseError))
            }
            completion(.success(currencies))
        }.resume()
    }
}

enum DownloaderError: Error {
    case badURL
    case noData
    case dataParseError
}
