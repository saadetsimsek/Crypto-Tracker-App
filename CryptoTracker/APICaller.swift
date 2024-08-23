//
//  APICaller.swift
//  CryptoTracker
//
//  Created by Saadet Şimşek on 21/08/2024.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    public var icons: [Icon] = []
    
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    private struct Constants {
        static let apiKey = "8BC625B1-33DD-4D5B-A92B-DB4F1ED1E434"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets"
    }
    
    private init(){
        
    }
    
    //MARK: - Public
    
    public func getAllCyrptoData(completion: @escaping (Result<[Crypto], Error>) -> Void){
        
        guard !icons.isEmpty else{
            whenReadyBlock = completion
            return
        }
        
        guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apiKey) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                //Decode response
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(cryptos.sorted { first, second -> Bool in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                }))
              
              //  completion(.success(cryptos))
                
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getAllIcons(){
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55?apikey="  + Constants.apiKey) else { //"https://rest.coinapi.io/v1/assets/icons/size - size bir yer tutucudur, değiştirilmelidir.
            return
        }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReadyBlock{
                    self?.getAllCyrptoData(completion: completion)
                    self?.whenReadyBlock = nil //tekrar tetiklenmesini önler
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}


