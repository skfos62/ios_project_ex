//
//  LoginAPI.swift
//  ios-shopping-mall
//
//  Created by 정나래 on 2020/11/22.
//

import Foundation
import Combine


class LoginAPI {
    
    
}

extension LoginAPI {
    // 로그인 하는 api
  
    static func request(_ path: ApiConfigs.APIPath, httpData: LoginRequest, httpMethod: String) -> AnyPublisher<LoginRespone, Error> {
        let body = LoginRequest(profileEmail: httpData.profileEmail, password: httpData.password, deviceId: httpData.deviceId, deviceOs: httpData.deviceOs, deviceModel: httpData.deviceModel, signinToken: httpData.signinToken, appVersion: "1.0")
     
        let checker = JSONSerialization.isValidJSONObject(body)
        print("json으로 바꿀수 있을지 없을지 확인 : \(checker)")

        // json 변환 인코더
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // 인코딩시 가독성을 높인다.


        // 통신 진행할 http Url 구성
        var request = URLRequest(url:ApiConfigs.Network.baseUrl.appendingPathComponent(ApiConfigs.APIPath.Login.rawValue))
        
        // http body에 담을 json 구성
        do {
          let data = try encoder.encode(body)
          print("json 만들기")
          print(String(data: data, encoding: .utf8)!)
          
          request.httpBody = data
            
        } catch {
          print(error.localizedDescription)
        }
        
        // http 보내는 형식 --- POST
        request.httpMethod = httpMethod
        
        // header정의하는 코드
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // 보낸 주소값 확인
        URLlog(request: request)
        
        return ApiConfigs.Network.apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
            
            
    }
    
}
