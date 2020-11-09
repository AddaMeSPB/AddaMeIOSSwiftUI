//
//  Environment.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 02.11.2020.
//

import Foundation

public enum EnvironmentKeys {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let rootURL = "ROOT_URL"
            static let webSocketURL = "WEB_SOCKET_URL"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        
        return dict
    }()
    
    // MARK: - Plist values
    static let rootURL: URL = {
        
        guard let rootURLstring = EnvironmentKeys.infoDictionary[Keys.Plist.rootURL] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        
        guard let url = URL(string: rootURLstring) else {
            fatalError("Root URL is invalid")
        }
        
        return url
    }()
    
    static let webSocketURL: URL = {
      
        guard let webSocketString = EnvironmentKeys.infoDictionary[Keys.Plist.webSocketURL] as? String else {
            fatalError("WEB SOCKET URL Key not set in plist for this environment")
        }
        
        guard let url = URL(string: webSocketString) else {
            fatalError("WEB SOCKET URL is invalid")
        }
        
        return url
    }()
    
}
