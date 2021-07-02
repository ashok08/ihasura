//
//  APIRequest.swift
//  ihasura
//
//  Created by Ashok on 26/06/21.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import Foundation

let REQUEST_TIMEOUT: TimeInterval = 20

class APIRequest: NSObject {
    
    static let shared = APIRequest()
    
    func postRequest<T: BaseMappable>(token : String, params: [String : AnyObject], ofType:T.Type, onSuccess: @escaping (T) -> Void, onError: @escaping (Error?) -> Void){
        let url = "https://ihasura.hasura.app/v1/graphql"
        let parameter : Parameters = params
        
        let header : HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header, interceptor: nil)
            .responseObject { (response:AFDataResponse<T>) in
                switch response.result{
                case .success(let value):
                    if let status_code = response.response?.statusCode, (status_code == 401) {
                       print("error")
                    }else {
                        onSuccess(value)
                    }
                case .failure(let error):
                    onError(error)
                    return
                }
            }
    }

}
