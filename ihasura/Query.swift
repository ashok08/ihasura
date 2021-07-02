//
//  Query.swift
//  ihasura
//
//  Created by Ashok on 30/06/21.
//

import Foundation
class Query : NSObject {
    
    static let shared = Query()
    
    func termsOfUse() -> [String:AnyObject]{
        let params : [String:AnyObject] = ["query":"{social_media{app_name}}" as AnyObject]
        return params
    }
}
