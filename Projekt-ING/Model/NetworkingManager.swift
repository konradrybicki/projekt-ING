//
//  NetworkingManager.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 21/04/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import Foundation
//import Alamofire

//klasa zarządzająca połączeniem

class NetworkingManager {
    
    //TODO: klasa "statyczna" NM -> Singleton ?
    
    private static let urlString = "https://jsonplaceholder.typicode.com"
    
    //TODO: metoda generyczna - możliwość dekodowania każdego typu dekodowalnych danych (jak na razie możliwe jest jedynie dekodowanie postów)
    static func getJsonData(completionHandler: @escaping(Result<[Post], Error>) -> Void) {
        
        //Opcja 1 - klasyczny networking
        //------------------------------
        
        //1. Adres URL
        
        guard let url = URL(string: self.urlString + "/posts") else {
            print("URL parsing failed.")
            return
        }
        
        //2. Ustanowienie sesji (bez konkretnego adresu - jak odpalenie przeglądarki)
        
        let session = URLSession(configuration: .default)

        //3. Zapytanie o dane
        
        let request = session.dataTask(with: url) { (data, response, error) in //metoda zwracająca dane, odpowiedź oraz ew błąd
            
            if error != nil {
                
                //wysyłamy sygnał do handler'a będącego parametrem naszej metody - dzięki temu przekażemy zdekodowane dane "na zewnątrz"
                
                completionHandler(.failure(error!))
                return
            }
            
            //pomijamy kwestię odpowiedzi serwera..
            
            guard let safeData = data else {
                completionHandler(.failure(error!))
                return
            }
                    
            //4. Dekodowanie
            
            let decodedData:[Post]
            let decoder = JSONDecoder()
            
            //do catch <=> try catch
            do {
                decodedData = try decoder.decode([Post].self, from: safeData)
                
                completionHandler(.success(decodedData))
            }
            catch {
                completionHandler(.failure(error))
            }
        }
        
        request.resume()
        
        //TODO: Opcja 2 - Alamofire
        //-------------------------
        
        //..
    }
}
