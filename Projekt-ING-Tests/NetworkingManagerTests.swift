//
//  NetworkingManagerTests.swift
//  Projekt-ING-Tests
//
//  Created by Konrad Rybicki on 23/05/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import XCTest
@testable import Projekt_ING

class NetworkingManagerTests: XCTestCase {
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testFetchUrl() throws {
        
        var postsUrl:URL!
        var commentsUrl:URL!
        var usersUrl:URL!
        var photosUrl:URL!
        var albumsUrl:URL!
        
        postsUrl = NetworkingManager.fetchUrl(withCatalogOfType: Post.self)
        commentsUrl = NetworkingManager.fetchUrl(withCatalogOfType: Comment.self)
        usersUrl = NetworkingManager.fetchUrl(withCatalogOfType: User.self)
        photosUrl = NetworkingManager.fetchUrl(withCatalogOfType: Photo.self)
        albumsUrl = NetworkingManager.fetchUrl(withCatalogOfType: Album.self)
        
        //parse: URL -> String - do porównań w asercjach (moim zdaniem, taki układ kodu wygląda czytelniej, niż w przypadku parsowania w samych asercjach)
        
        let apiUrlString = NetworkingManager.getApiUrlString
        
        XCTAssertEqual(postsUrl.absoluteString, apiUrlString + "/posts")
        XCTAssertEqual(commentsUrl.absoluteString, apiUrlString + "/comments")
        XCTAssertEqual(usersUrl.absoluteString, apiUrlString + "/users")
        XCTAssertEqual(photosUrl.absoluteString, apiUrlString + "/photos")
        XCTAssertEqual(albumsUrl.absoluteString, apiUrlString + "/albums")
        
        //absoluteString (kl. URL) - pole przechowujące tylko i wyłącznie ADRES url (obiekt klasy URL zawiera też inne dane)
    }
    
    func testGetJson() throws {
        
        var posts:[Post]?
        var comments:[Comment]?
        var users:[User]?
        var photos:[Photo]?
        var albums:[Album]?
        
        var error_posts:Error?
        var error_comments:Error?
        var error_users:Error?
        var error_photos:Error?
        var error_albums:Error?
        
        NetworkingManager.getJson(ofType: Post.self) { result in
            switch result {
            case .failure(let error):
                error_posts = error
            case .success(let data):
                posts = data
            }
        }
        NetworkingManager.getJson(ofType: Comment.self) { result in
            switch result {
            case .failure(let error):
                error_comments = error
            case .success(let data):
                comments = data
            }
        }
        NetworkingManager.getJson(ofType: User.self) { result in
            switch result {
            case .failure(let error):
                error_users = error
            case .success(let data):
                users = data
            }
        }
        NetworkingManager.getJson(ofType: Photo.self) { result in
            switch result {
            case .failure(let error):
                error_photos = error
            case .success(let data):
                photos = data
            }
        }
        NetworkingManager.getJson(ofType: Album.self) { result in
            switch result {
            case .failure(let error):
                error_albums = error
            case .success(let data):
                albums = data
            }
        }
        
        sleep(15) //czas dla API na sztywno - testowanie mechanizmów "czekających" na dane nie jest meritum tego testu
        
        XCTAssertTrue((posts != nil) || (error_posts != nil))
        XCTAssertTrue((comments != nil) || (error_comments != nil))
        XCTAssertTrue((users != nil) || (error_users != nil))
        XCTAssertTrue((photos != nil) || (error_photos != nil))
        XCTAssertTrue((albums != nil) || (error_albums != nil))
    }
    
    func testHandleJsonGetting_oneParam() throws {
        
        var posts:[Post]?
        var comments:[Comment]?
        var users:[User]?
        var photos:[Photo]?
        var albums:[Album]?
        
        var error_posts:Error?
        var error_comments:Error?
        var error_users:Error?
        var error_photos:Error?
        var error_albums:Error?
        
        NetworkingManager.handleJsonGetting(requestedType: Post.self, dataContainer: &posts, errorContainer: &error_posts);
        NetworkingManager.handleJsonGetting(requestedType: Comment.self, dataContainer: &comments, errorContainer: &error_comments);
        NetworkingManager.handleJsonGetting(requestedType: User.self, dataContainer: &users, errorContainer: &error_users);
        NetworkingManager.handleJsonGetting(requestedType: Photo.self, dataContainer: &photos, errorContainer: &error_photos);
        NetworkingManager.handleJsonGetting(requestedType: Album.self, dataContainer: &albums, errorContainer: &error_albums);
        
        XCTAssertTrue((posts != nil) || (error_posts != nil))
        XCTAssertTrue((comments != nil) || (error_comments != nil))
        XCTAssertTrue((users != nil) || (error_users != nil))
        XCTAssertTrue((photos != nil) || (error_photos != nil))
        XCTAssertTrue((albums != nil) || (error_albums != nil))
    }

    func testHandleJsonGetting_twoParams() throws {
        
        //metoda działa dla każdego dekodowalnego typu, nie trzeba więc testować wszystkich możliwych kombinacji,
        //a po prostu sprawdzić, czy zadziała dla dwóch, jakichkolwiek parametrów
        
        var posts:[Post]?
        var comments:[Comment]?
        
        var error_posts:Error?
        var error_comments:Error?
        
        NetworkingManager.handleJsonGetting(requestedType1: Post.self, requestedType2: Comment.self,
                                            dataContainer1: &posts, dataContainer2: &comments,
                                            errorContainer1: &error_posts, errorContainer2: &error_comments)
        
        XCTAssertTrue(((posts != nil) || (error_posts != nil)) && ((comments != nil) || (error_comments != nil)))
    }
    
    func testHandleJsonGetting_threeParams() throws {
        
        //j.w.
        
        var posts:[Post]?
        var comments:[Comment]?
        var users:[User]?
        
        var error_posts:Error?
        var error_comments:Error?
        var error_users:Error?
        
        NetworkingManager.handleJsonGetting(requestedType1: Post.self, requestedType2: Comment.self, requestedType3: User.self,
                                            dataContainer1: &posts, dataContainer2: &comments, dataContainer3: &users,
                                            errorContainer1: &error_posts, errorContainer2: &error_comments, errorContainer3: &error_users)
        
        XCTAssertTrue(((posts != nil) || (error_posts != nil)) &&
                      ((comments != nil) || (error_comments != nil)) &&
                      ((users != nil) || (error_users != nil)))
    }
}
