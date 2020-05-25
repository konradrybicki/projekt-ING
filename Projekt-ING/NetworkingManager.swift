//
//  NetworkingManager.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 21/04/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import Foundation

//klasa zarządzająca połączeniem

class NetworkingManager {
    
    private static let apiUrlString = "https://jsonplaceholder.typicode.com"
    
    //internal - testy
    internal static var getApiUrlString:String { return apiUrlString } //wrap
/*
    -------------------------------------------------------------------------------------
    Sposoby na implementację dostępności typu 'readonly' w Swifcie:
    - public/internal let
    - private(set) var
    - public/internal var, getter (computed properties)
    - private var/let + getter w osobnej zmiennej publicznej (wrap) - podobnie jak metody get../set.. w Javie
    -------------------------------------------------------------------------------------
*/
    static func handleJsonGetting<T: Decodable>(requestedType:T.Type, dataContainer: inout [T]?, errorContainer: inout Error?) -> Void {
        
        //w naszym completionHandlerze nie można bezpośrednio przekazać wartości do parametru "referencyjnego",
        //stąd też pomysł na obejście tego obostrzenia:
        
        var closureInoutEscaper_data:[T]?
        var closureInoutEscaper_error:Error?
        
        getJson(ofType: requestedType) { result in
            switch result {
            case .failure(let error):
                closureInoutEscaper_error = error
            case .success(let data):
                closureInoutEscaper_data = data
            }
        }
        
        //czas dla API
        
        print("Waiting for API..")
        
        while(true){
            if closureInoutEscaper_error != nil {
                errorContainer = closureInoutEscaper_error!
                break
            }
            if closureInoutEscaper_data != nil {
                dataContainer = closureInoutEscaper_data!
                break
            }
        }
        print("API response recieved.")
    }
    
    static func handleJsonGetting <T1: Decodable, T2: Decodable>(
        requestedType1: T1.Type, requestedType2: T2.Type,
        dataContainer1: inout [T1]?, dataContainer2: inout [T2]?,
        errorContainer1: inout Error?, errorContainer2: inout Error?
    ) -> Void {
        
        //przez błędy związane z kolejnością "wchodzenia" wartości do tablic oraz indeksowaniem tuple'i,
        //musiałem zaimplementować mechanizmy wewnątrz handlera w sposób manualny, bez tablic czy pętli
        
        var closureInoutEscaper_data1:[T1]?
        var closureInoutEscaper_data2:[T2]?
        var closureInoutEscaper_error1:Error?
        var closureInoutEscaper_error2:Error?
        
        getJson(ofType: requestedType1) { result in
            switch result {
            case .failure(let error):
                closureInoutEscaper_error1 = error
            case .success(let data):
                closureInoutEscaper_data1 = data
            }
        }
        getJson(ofType: requestedType2) { result in
            switch result {
            case .failure(let error):
                closureInoutEscaper_error2 = error
            case .success(let data):
                closureInoutEscaper_data2 = data
            }
        }
        
        print("Waiting for API..")
        
        while(true){
            
            //wystarczy jeden
            
            if closureInoutEscaper_error1 != nil { errorContainer1 = closureInoutEscaper_error1; break }
            if closureInoutEscaper_error2 != nil { errorContainer2 = closureInoutEscaper_error2; break }
            
            //potrzeba wszystkich
            
            if (closureInoutEscaper_data1 != nil) && (closureInoutEscaper_data2 != nil) {
                dataContainer1 = closureInoutEscaper_data1
                dataContainer2 = closureInoutEscaper_data2
                break
            }
        }
        print("API response recieved.")
    }

    static func handleJsonGetting <T1: Decodable, T2: Decodable, T3: Decodable>(
        requestedType1: T1.Type, requestedType2: T2.Type, requestedType3: T3.Type,
        dataContainer1: inout [T1]?, dataContainer2: inout [T2]?, dataContainer3: inout [T3]?,
        errorContainer1: inout Error?, errorContainer2: inout Error?, errorContainer3: inout Error?
    ) -> Void {
        
        var closureInoutEscaper_data1:[T1]?
        var closureInoutEscaper_data2:[T2]?
        var closureInoutEscaper_data3:[T3]?
        var closureInoutEscaper_error1:Error?
        var closureInoutEscaper_error2:Error?
        var closureInoutEscaper_error3:Error?
        
        getJson(ofType: requestedType1) { result in
            switch result {
            case .failure(let error):
                closureInoutEscaper_error1 = error
            case .success(let data):
                closureInoutEscaper_data1 = data
            }
        }
        getJson(ofType: requestedType2) { result in
            switch result {
            case .failure(let error):
                closureInoutEscaper_error2 = error
            case .success(let data):
                closureInoutEscaper_data2 = data
            }
        }
        getJson(ofType: requestedType3) { result in
            switch result {
            case .failure(let error):
                closureInoutEscaper_error3 = error
            case .success(let data):
                closureInoutEscaper_data3 = data
            }
        }
        
        print("Waiting for API..")
        
        while(true){
            
            if closureInoutEscaper_error1 != nil { errorContainer1 = closureInoutEscaper_error1; break }
            if closureInoutEscaper_error2 != nil { errorContainer2 = closureInoutEscaper_error2; break }
            if closureInoutEscaper_error3 != nil { errorContainer3 = closureInoutEscaper_error3; break }
            
            if (closureInoutEscaper_data1 != nil) && (closureInoutEscaper_data2 != nil) && (closureInoutEscaper_data3 != nil) {
                dataContainer1 = closureInoutEscaper_data1
                dataContainer2 = closureInoutEscaper_data2
                dataContainer3 = closureInoutEscaper_data3
                break
            }
        }
        print("API response recieved.")
    }
    
    //internal - testy
    internal static func getJson<T: Decodable>(ofType contentType: T.Type, completionHandler: @escaping(Result<[T], Error>) -> Void) {
        
        let url = fetchUrl(withCatalogOfType: contentType)
        
        let session = URLSession(configuration: .default)
        
        let request = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                completionHandler(.failure(error!))
                return
            }
            
            //response ..
            
            guard let safeData = data else {
                completionHandler(.failure(error!))
                return
            }
        
            let decoder = JSONDecoder()
            
            guard let decodedData = try? decoder.decode([T].self, from: safeData) else {
                completionHandler(.failure(error!))
                return
            }
            completionHandler(.success(decodedData))
        }
        request.resume()
    }
    
    //internal - testy
    internal static func fetchUrl<T: Decodable>(withCatalogOfType contentType: T.Type) -> URL {

        var apiUrlString = self.apiUrlString

        if contentType == Post.self {
            apiUrlString += "/posts"
        }
        else if contentType == Comment.self {
            apiUrlString += "/comments"
        }
        else if contentType == User.self {
            apiUrlString += "/users"
        }
        else if contentType == Photo.self {
            apiUrlString += "/photos"
        }
        else if contentType == Album.self {
            apiUrlString += "/albums"
        }
        
        guard let fetchedUrl = URL(string: apiUrlString) else {
            print("URL adress fetch inside 'fetchUrl()' method failed unexpectedely.")
            exit(1)
        }

        return fetchedUrl
    }
}
