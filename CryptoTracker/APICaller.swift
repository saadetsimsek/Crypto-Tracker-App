//
//  APICaller.swift
//  CryptoTracker
//
//  Created by Saadet Şimşek on 21/08/2024.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = "8BC625B1-33DD-4D5B-A92B-DB4F1ED1E434"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets"
    }
    
    private init(){
        
    }
    
    //MARK: - Public
    
    public func getAllCyrptoData(completion: @escaping (Result<[Crypto], Error>) -> Void){
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
                completion(.success(cryptos))
                
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


