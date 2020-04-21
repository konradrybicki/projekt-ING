//
//  NetworkingManager.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 21/04/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import Foundation
//TODO: import Alamofire

//struktury dla JSON'a  (TODO: Struktury w osobnym pliku)

struct Post: Decodable {
    let userId:Int
    let id:Int
    let title:String
    let body:String
}

struct Comment: Decodable {
    let postId:Int
    let id:Int
    let name:String
    let email:String
    let body:String
}

struct Album: Decodable {
    let userId:Int
    let id:Int
    let title:String
}

struct Photo: Decodable {
    let albumId:Int
    let id:Int
    let title:String
    let url:String
    let thumbnailUrl:String
}

struct User: Decodable {
    //TODO: struct dla użytkownika
}

//klasa zarządzająca połączeniem

class NetworkingManager {
    
    //TODO: klasa "statyczna" -> Singleton ?
    
    private static let urlString = "https://jsonplaceholder.typicode.com"
    
    //TODO: metoda generyczna - możliwość dekodowania każdego typu dekodowalnych danych (jak na razie możliwe jest jedynie dekodowanie postów)
    static func getJsonData() -> Void {
        
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

        let request = session.dataTask(with: url) { (data, response, error) in //metoda zwracająca dane, odpowiedź oraz ew błąd zapytania
            
            if error != nil {
                print(error!)
                return
            }
            
            //pomijamy kwestię odpowiedzi serwera..
            
            guard let safeData = data else {
                print("No data to collect from the server.")
                return
            }
                    
            //4. Dekodowanie
            
            let decodedData:[Post]
            let decoder = JSONDecoder()
            
            //do catch <=> try catch
            do {
                decodedData = try decoder.decode([Post].self, from: safeData)
                
                print("Decoding complete.\n\nDecoded data (posts):")
                for i in 0..<decodedData.count {
                    print("\n\nUser ID: \(decodedData[i].userId)")
                    print("\nPost ID: \(decodedData[i].id)")
                    print("\nTitle: \(decodedData[i].title)")
                    print("\nContent: \(decodedData[i].body)")
                }
                print("\n\nEnd.")
            }
            catch {
                print(error)
                return
            }
        }
        request.resume()
        
        //TODO: Opcja 2 - Alamofire
        //-------------------------
    }
}

