//
//  LoginModel.swift
//  ios-shopping-mall
//
//  Created by 정나래 on 2020/10/20.
//

import Foundation
import SwiftUI
import Combine

// -- (가입여부체크 Request Model) --
struct LoginModel:Codable {
  let userName: String?
  let userPassword: String?
}

// -- (가입여부체크 Reponse Model) --
struct usersCheckResponse: Codable {
    let message: String?
    var signin_token: String?
}

// -- (로그인 Request Model) -- 
struct LoginRequest: Codable {
    let registeredType:String? = "email"
    let profileEmail:String?
    let password:String?
    let deviceId:String?
    let deviceOs:String?
    let deviceModel:String?
    let signinToken:String?
    let appVersion:String?
    
    enum CodingKeys: String, CodingKey {
        case registeredType = "registered_type"
        case profileEmail = "profile_email"
        case password = "password"
        case deviceId = "device_id"
        case deviceOs = "device_os"
        case deviceModel = "device_model"
        case signinToken = "signin_token"
        case appVersion = "app_version"
    }
}

// -- (로그인 Reponse Model) --
struct LoginRespone: Codable{
    let accessToken:String?
    let user:User
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case user = "user"
    }
}
struct User: Codable {
    let id:Int?
    let profileNickname:String?
    let profileEmail:String?
    let profileImageUrl:String?
    let createdAt:String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileNickname = "profile_nickname"
        case profileEmail = "profile_email"
        case profileImageUrl = "profile_image_url"
        case createdAt = "created_at"
    }
}


// 로그인한 정보를 저장하는 static 변수 (environment Object)에 저장할 클래스
class LoginResponseClass:ObservableObject {
    @Published var loginResponse:LoginRespone
    
    init() {
        self.loginResponse = LoginRespone(accessToken: nil, user: User(id: nil, profileNickname: nil, profileEmail: nil, profileImageUrl: nil, createdAt: nil))
    }
}

// -- (로그인 Reponse closure Model) --
class LoginResponeClass: Decodable{
    let accessToken:String?
    let user:UserClass
    
    }

class UserClass: Decodable {
    let id:Int?
    let profileNickname:String?
    let profileEmail:String?
    let profileImageUrl:String?
    let createdAt:String?
}


// -- (옵셔널 바인딩 할때 사용하는 Response Model) --
struct optinalUser: Codable {
    var id:Int
    var profileNickname:String
    var profileEmail:String
    var profileImageUrl:String
    var createdAt:String
}


