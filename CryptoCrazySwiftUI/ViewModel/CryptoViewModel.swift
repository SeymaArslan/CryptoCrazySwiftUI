//
//  CryptoViewModel.swift
//  CryptoCrazySwiftUI
//
//  Created by Seyma on 23.10.2023.
//

import Foundation

class CryptoListViewModel: ObservableObject {
    
    @Published var cryptoList = [CryptoViewModel]()  // liste de herhangi bir değişiklik olunca MainView da bu listeyi kullanan UI lar bunu fark etsin istiyoruz bu yüzden @Published ekleyerek veri listesini oluşturuyoruz. Yani burada yayın yapacağız MainView da ise gözlem yapacağız (subscribe yaparak)
    
    let webservice = Webservice()
    func downloadCryptos(url: URL) {
        webservice.downloadCurrencies(url: url) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let cryptos):
                if let cryptos = cryptos {
                    // cryptoList artık kullanıcı arayüzünü etkileyecek bir şey yapacağı için cryptoList in thread ini main yapmalıyız.
                    DispatchQueue.main.async {
                        self.cryptoList = cryptos.map(CryptoViewModel.init)   // map ile bir modeli başka bir modele çevireceğiz, nereden çevirileceğini map ( ..) burada yazıyoruz.. böylelikle artık cryptoList imizi indirdiğimiz if let cryptos = cryptos cryptos u alıp cryptoList imizin içerisine kaydedebiliriz.
                    }

                }
            }
        }
    }
}


struct CryptoViewModel {
    let crypto: CryptoCurrency
    var id: UUID? {
        crypto.id
    }
    var currency: String {
        crypto.currency
    }
    var price: String {
        crypto.price
    }
}
