//
//  ViewController.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 21/04/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pobieranie danych
        
        NetworkingManager.getJsonData { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let posts):
                for i in 0..<posts.count {
                    print("\n\nUser ID: \(posts[i].userId)")
                    print("\nPost ID: \(posts[i].id)")
                    print("\nTitle: \(posts[i].title)")
                    print("\nContent: \(posts[i].body)")
                }
                print("\n\nEnd.")
            }
        }
        
        //..
    }
}

