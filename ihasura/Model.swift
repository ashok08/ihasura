//
//  Model.swift
//  ihasura
//
//  Created by Ashok on 30/06/21.
//

import Foundation
import ObjectMapper

class Social: NSObject, Mappable {
    
    var data = SocialMedia()
    
    override init() { }
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}

class SocialMedia: NSObject, Mappable {
    
    var socialMedia = [SocialMediaDetails]()
    
    override init() { }
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        socialMedia <- map["social_media"]
    }
}

class SocialMediaDetails: NSObject, Mappable {
    
    var appName = String()
    
    override init() { }
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        appName <- map["app_name"]
    }
}
