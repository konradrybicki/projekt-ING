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
    
    private static let urlString = "https://jsonplaceholder.typicode.com"
    
    //metoda generyczna - możliwość dekodowania każdego typu dekodowalnych danych
    
    static func getJsonData<T: Decodable>(ofType contentType: T.Type, completionHandler: @escaping(Result<[T], Error>) -> Void) {
        
        //Opcja 1 - klasyczny networking
        //------------------------------
        
        //1. Adres URL (fetch)
        
        var apiCatalog:String!
        
        if contentType == Post.self {
            apiCatalog = "/posts"
        }
        else if contentType == Comment.self {
            apiCatalog = "/comments"
        }
        else if contentType == Album.self {
            apiCatalog = "/albums"
        }
        else if contentType == Photo.self {
            apiCatalog = "/photos"
        }
        else if contentType == User.self {
            apiCatalog = "/users"
        }
        
        let url = URL(string: self.urlString + apiCatalog)!
        
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
            
            //sp. 1 - do catch (bardziej klasyczny)
        /*
            let decodedData:[T]
            let decoder = JSONDecoder()
            
            //do catch <=> try catch
            do {
                decodedData = try decoder.decode([T].self, from: safeData)
                completionHandler(.success(decodedData))
            }
            catch {
                completionHandler(.failure(error))
            }
        */
            //sp. 2 - guard, optional (bardziej Swift'owy ;) )
        
            let decoder = JSONDecoder()
            
            guard let decodedData = try? decoder.decode([T].self, from: safeData) else {
                completionHandler(.failure(error!))
                return
            }
            completionHandler(.success(decodedData))
        }
        
        request.resume()
        
        //TODO: Opcja 2 - Alamofire
        //-------------------------
        
        //..
    }
}
