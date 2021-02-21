//
//  Log.swift
//  ios-shopping-mall
//
//  Created by 정나래 on 2020/11/23.
//

import Foundation
//class Log {
    
 func URLlog(request: URLRequest){

        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)

        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"

        var requestLog = "\n---------- Request ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            requestLog += "Body: \n\(bodyString)\n"
        }

        requestLog += "\n------------------------->\n";
        print(requestLog)
    }
func responseLog(data: Data?) {
  
    
}
func Responselog(data: Data?, response: HTTPURLResponse?){

        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"

        var responseLog = "\n<---------- Respone ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }
        // http status code
        if let statusCode =  response?.statusCode{
            responseLog += "HTTP Status Code :  \(statusCode) \(path)?\(query)\n\n"
        }
        if let host = components?.host{
            responseLog += "Host: \(host)\n\n"
        }
        // http status code
//        responseLog += "header : \n"
//        for (key,value) in response?.allHeaderFields ?? [:] {
//            responseLog += "\(key): \(value)\n"
//        }
    
        // body
        if let body = data{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            responseLog += "\n body : \n\(bodyString)\n"
        }
        // error
    
//        if let error = error{
//            responseLog += "\nError: \(error.localizedDescription)\n"
//        }

        responseLog += "<------------------------\n";
        print(responseLog)
    }

// 페이지의 데이터
func DataBindingLog(from:String, data:String){
    print("from : \(from) , data : \(data)")
}

    

