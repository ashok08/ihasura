//
//  Model.swift
//  ihasura
//
//  Created by Ashok on 30/06/21.
//

import Foundation
import ObjectMapper

class Users: NSObject, Mappable {
    
    var data = Datas()
    
    override init() { }
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}

class Datas: NSObject, Mappable {
    
    var insertdata = AffectedRows()
    var checkdata = [UserDetails]()
    var insertPosts = AffectedRows()

    override init() { }
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        insertdata <- map["insert_users"]
        checkdata <- map["users"]
        insertPosts <- map["insert_posts"]

    }
}

class AffectedRows: NSObject, Mappable {
    
    var affectedRows = 0
    
    override init() { }
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        affectedRows <- map["affected_rows"]
    }
}

class UserDetails: NSObject, Mappable {
    
    var name = String()
    
    override init() { }
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
    }
}

