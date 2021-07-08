//
//  Query.swift
//  ihasura
//
//  Created by Ashok on 30/06/21.
//

import Foundation
class Query : NSObject {
    
    static let shared = Query()
    
    func checkUser(authID:String) -> [String:AnyObject]{
        let params: [String: AnyObject] =  ["query":"query{users(where: {auth_id: {_eq: \"\(authID)\"}}) { name}}" as AnyObject]
        return params
    }
    
    func inserUserDetails(name:String,authID:String,image:String) -> [String:AnyObject]{
        let params: [String: AnyObject] =  ["query":"mutation{insert_users( objects: {auth_id: \"\(authID)\", name: \"\(authID)\", profile_image: \"\(image)\"}){affected_rows}}" as AnyObject]
        return params
    }
   
    func inserUserPostDetails(content:String,authID:String,image:String) -> [String:AnyObject]{
        let params: [String: AnyObject] =  ["query":"mutation{insert_posts(objects: {post_content: \"\(content)\", post_image: \"\(image)\", user_id: \"\(authID)\"}){affected_rows}}" as AnyObject]
        return params
    }
}
