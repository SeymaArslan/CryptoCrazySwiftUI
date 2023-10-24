//
//  Webservice.swift
//  CryptoCrazySwiftUI
//
//  Created by Seyma on 23.10.2023.
// 

import Foundation

class Webservice {
    
//    func downloadCurrenciesAsync(url: URL) async throws -> [CryptoCurrency] { // buraya throws ekleme sebebimiz hata çıkacaksa da bu fonksiyonda değil bu fonksiyonu kullanacak yerde ele alacağım orada do try catch yapacağız diyoruz
//        let (data, _) = try await URLSession.shared.data(from: url) // await async ten geldi try hata attığı için geldi try dan sonraki hatayı gidermek için fonksiyona throws ekledik. let (data, response) burada response kullanmadığımız için _ kullanabiliriz.
//        let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data)
//        return currencies ?? []
//    }
    
    
    func downloadCurrenciesContinuation(url: URL) async throws -> [CryptoCurrency] {
        try await withCheckedThrowingContinuation { continuation in   // bu fonksiyonun yaptığı şey güncel task'ı suspend etmek yani duraklatmak.. burada herhangi bir fonksiyonu async olmasada async hale getirip istediğimiz zaman duraklatıp devam ettirebiliyoruz, hatta manuel olarak devam ettireceğimiz yeri kendimiz seçeceğiz (Bu arada buna aslında sistem karar veriyor.) Bu fonksyion async ve throws olduğu için başına try ve await koyuyoruz.
            
            // burada değer döndürmeden önce async olmayan bir fonksiyonu da çağırabiliriz ve isteğimiz zaten bu
            downloadCurrencies(url: url) { result in
                switch result{
                case .success(let cryptos):
                    continuation.resume(returning: cryptos ?? [])
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
        }
    }
    
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
