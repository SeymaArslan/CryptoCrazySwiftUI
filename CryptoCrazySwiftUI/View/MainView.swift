//
//  ContentView.swift
//  CryptoCrazySwiftUI
//
//  Created by Seyma on 22.10.2023.
// 

import SwiftUI

struct MainView: View {
    @ObservedObject var cryptoListViewModel: CryptoListViewModel
    
    init() {
        self.cryptoListViewModel = CryptoListViewModel()
    }
    
    var body: some View {
        NavigationView {
            List(cryptoListViewModel.cryptoList, id: \.id) { crypto in
                VStack {
                    Text(crypto.currency)
                        .font(.title3)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(crypto.price)
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.navigationTitle(Text("Crypto Crazy"))
        }.onAppear { // onAppear bu görünüm oluşturulunca ne yapacağını sorar
            cryptoListViewModel.downloadCryptos(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
        }
    }
}

#Preview {
    MainView()
}
