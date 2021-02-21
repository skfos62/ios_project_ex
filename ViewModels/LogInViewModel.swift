//
//  SignInVM.swift
//  ios-shopping-mall
//
//  Created by 정나래 on 2020/10/19.
//

import Foundation
import SwiftUI
import Combine


class LogInViewModel: ObservableObject {
    @EnvironmentObject var longinUserInfo:LoginResponseClass
    // 로그인시 서버에 가입여부 체크 하고. 로그인 진행할것
    // 가입여부 체크한뒤에 서버에서 응답오는 데이터를 확인하는 변수
    @Published var showAlert:usersCheckResponse = usersCheckResponse(message:"디폴트", signin_token: "디폴트")
    
    // 회원가입 할때 상태를 체크하는 변수
    @Published var userJoinCheckStatus:String = ""
    
    
    // 가입여부 상태를 체크하는 변수
    @Published var userCheckStatus:String = ""
    // alert에 띄울 text
    @Published var showAlertText:String = ""
    // alert에 사용되는 bool
    @Published var statusJoin:Bool = false
    // 로그인 모달에 사용되는 bool
    @Published var stateLogin:Bool = false
    // 로그인 모달에 사용되는 bool
    @Published var showLogin:Bool = false
    // user가 작성하는 텍스트필드 데이터값 (아이디)
    @Published var userName:String = ""
    // user가 작성하는 텍스트필드 데이터값 (비밀번호)
    @Published var userPassword:String = "" {
        didSet {
            objectWillChange.send()
        }
    }
    // 서버에서 받아온 사인토큰
    @Published var userSignToken:String = ""
    // alert에 사용되는 bool
    @Published var modalStatus:String = ""
    @Published var loginStatus:String = ""
    @Published var boolLoginStatus:Bool = false
    @Published var userInfoImage:URL = URL(string: "")
    @Published var profileNickname:String = ""
    @Published var profileEmail:String = ""
    @Published var profileImageURL:String = ""
    @Published var Test:String = ""
    @Published var Test2:Int = 1
    // 유저가 로그인한다음에 받아오는 데이터
    @Published var loginRespone:LoginRespone = LoginRespone(accessToken: "nil", user: User(id: nil, profileNickname: nil, profileEmail: nil, profileImageUrl: nil, createdAt: nil))
    @Published var accessToken:String = ""
    // 유저가 선택한 이미지를 담아놓는 변수
    @Published var image: UIImage?
    @Published var loginProfileEmail: String?
    @Published var loginProfileNickname: String?

    var cancellable: AnyCancellable?
    
    // 가입유저를 체크하는 함수
    func userCheck() {
        let userCheckRequset = LoginModel(userName: userName, userPassword: userPassword)
        // 가입여부를 확인, 서버에 요청하는곳
        cancellable = UserCheckAPI.request(.UserCheck, httpData: userCheckRequset)
            .mapError({ (error) -> Error in // 5
                print("map 에러로그 : \(error)" )
                return error
            })
            .sink(receiveCompletion: { _ in }, // 6
                  receiveValue: {
                    print("서버 통신 결과값  : \($0)")
                    // 회원가입 할경우
                    if $0.message == "you_can_join" { // 회원가입 하는경우
                        print(" 로그인 가입 체크 여부 : 회원가입이 가능한 상태 ")
                        self.showAlert = $0
                        
                        // 서버에서 받아온 값은 옵셔널 값이기 때문에 해제해야한다.
                        // 옵셔널 바인딩 하는곳
                        if let responseMessage = self.showAlert.message {
                            self.userCheckStatus = responseMessage
                        }
                        
                        print(" 회원가입가능한상태 : \(self.userCheckStatus)")
                        self.statusJoin.toggle()
                        self.userJoinCheckStatus = "회원가입가능"
                        // 알러창에 띄울 텍스트
                        self.showAlertText = "이메일 혹은 비밀번호를 다시 확인해주세요"
                    } else if $0.message == "you_can_login" { // 로그인하는 경우
                        print(" 로그인 가입 체크 여부 : 로그인 가능한 상태 ")
                        self.showAlert = $0

                        // 서버에서 받아온 값은 옵셔널 값이기 때문에 해제해야한다.
                        // 옵셔널 바인딩 하는곳
                        if let responseMessage = self.showAlert.message, let responeSignToken = self.showAlert.signin_token  {
                            
                            self.userCheckStatus = responseMessage
                            self.userSignToken = responeSignToken
                        }

                        print("디바이스 정보 확인 : \(UIDevice.current.model)/\(UIDevice.current.name)/Apple")
                        print("디바이스 id 확인 : \(String(describing: UIDevice.current.identifierForVendor!))")
                        // 로그인을 진행하는 함수
                        self.userJoinCheckStatus = "이미가입된회원"
                        self.login()
                        
                    } else { // 이메일 형식이 다른경우
                        print("이메일을 확인해주세요")
                        self.showAlert = $0
                        // 알러창에 띄울 텍스트
                        self.showAlertText = "이메일을확인해주세요."
                        self.statusJoin.toggle()
                        
                    }
                    
                  })
    }
    // 로그인하는 함수
    func login(){
        // tabMyinfoPage로 로그인이 되었다는 알림을 보내줄 클로저
        let loginRequestData = LoginRequest(profileEmail: userName, password: userPassword, deviceId: "\(String(describing: UIDevice.current.identifierForVendor!))", deviceOs: "I", deviceModel: "\(UIDevice.current.model)/\(UIDevice.current.name)/Apple", signinToken: userSignToken, appVersion: "1.0")
        // 로그인 확인 
        cancellable = LoginAPI.request(.Login, httpData: loginRequestData, httpMethod: "post")
            .mapError({ (error) -> Error in // 5
                print("map 에러로그 : \(error)" )
                // 에러로그일때 나올 예외 처리 넣기
                self.showAlertText = "이메일 혹은 비밀번호를 다시 확인해주세요."
                self.statusJoin.toggle()
                return error
            })
            .sink(receiveCompletion: { data in
                
            }, // 6
            receiveValue: { [self] in
                print("로그인 서버 통신 결과값  : \($0)")
                if $0.accessToken == nil {
                    
                    print("비밀번호를 확인해주세요")
                    self.showLogin = true
                    print("view model 창 확인 : \(self.showLogin)")
                    // respone 값 매핑
                    let showLoginAlert = $0

                    // 알러창에 띄울 텍스트
                    self.showAlertText = "이메일 혹은 비밀번호를 다시 확인해주세요."
                    
                    // 서버에서 받아온 값은 옵셔널 값이기 때문에 해제해야한다.
                    // 옵셔널 바인딩 하는곳
                    if let responseAccessToken = showLoginAlert.accessToken {
                        self.userCheckStatus = responseAccessToken
                    }                    
                    self.statusJoin.toggle()
                    
                } else {
                    // 알러창에 띄울 텍스트
                    let userInfoRespone = $0.user
                    loginRespone = $0
                    self.showAlertText = "로그인 되었습니다."
                    self.statusJoin.toggle()
                    self.modalStatus = "로그인창닫기"
                    self.loginStatus = "로그인완료"
                    // 로그인이 진행되면 tabmyinfopage로 로그인이 완료됐다는 데이터를 보내야함
                    if let userNickname = userInfoRespone.profileNickname {
                        print(userNickname)
                        self.profileNickname = userNickname
                    }
                    if let userEmail = userInfoRespone.profileEmail {
                        self.profileEmail = userEmail
                    }
                    if let userImage = userInfoRespone.profileImageUrl {
                        self.profileImageURL = userImage
                    }
                    // 로그인 완료됐다는 bool
                    self.stateLogin = true
                    // 서버통신후 가져온 엑세스 토큰을 담아두는 변수
                    accessToken = $0.accessToken!
                    accessToken = loginRespone.accessToken!
                    // 유저 디폴트에 로그인 완료된 엑세스 토큰 저장하기
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    loginRespone = $0

                }
            })
    }

    func logout() {
        accessToken = UserDefaults.standard.object(forKey: "accessToken") as? String ?? ""
        // 로그아웃하는 서버 통신
        cancellable = LogoutAPI.request(.Logout, accessToken: accessToken, httpMethod: "POST")
            .mapError({ (error) -> Error in // 5
                print("map 에러로그 : \(error)" )
                return error
            })
            .sink(receiveCompletion: { _ in }, // 6
                  receiveValue: {
                    print("서버 통신 결과값  : \($0)")
                  })

        // 유저 디폴트에 저장된 엑세스토큰 지우기
        UserDefaults.standard.removeObject(forKey: "accessToken")
        print("엑세스 토큰이 잘 들어왔는지? : \(UserDefaults.standard.object(forKey: "accessToken") as? String ?? "")")
    }

    func getDate() {
        self.boolLoginStatus = true

        print(" 여기서 확인 : \(profileNickname)")
        print(" 여기서 확인 : \(profileEmail)")
        print(" 여기서 확인 : \(profileImageURL)")
    }
    
    func signupUserCheck(){
        let userCheckRequset = LoginModel(userName: userName, userPassword: userPassword)
        // 가입여부를 확인, 서버에 요청하는곳
        cancellable = UserCheckAPI.request(.UserCheck, httpData: userCheckRequset)
            .mapError({ (error) -> Error in // 5
                print("map 에러로그 : \(error)" )
                return error
            })
            .sink(receiveCompletion: { _ in }, // 6
                  receiveValue: {
                    print("서버 통신 결과값  : \($0)")
                    // 회원가입 할경우
                    if $0.message == "you_can_join" { // 회원가입 하는경우
                        print(" 로그인 가입 체크 여부 : 회원가입이 가능한 상태 ")
                        self.showAlert = $0
                        
                        // 서버에서 받아온 값은 옵셔널 값이기 때문에 해제해야한다.
                        // 옵셔널 바인딩 하는곳
                        if let responseMessage = self.showAlert.message {
                            self.userCheckStatus = responseMessage
                        }
                        
                        self.userJoinCheckStatus = "회원가입이 가능한 이메일입니다."
  
                        
                    } else if $0.message == "you_can_login" { // 로그인하는 경우
                        print(" 로그인 가입 체크 여부 : 로그인 가능한 상태 ")
                        self.showAlert = $0
                        
                        // 서버에서 받아온 값은 옵셔널 값이기 때문에 해제해야한다.
                        // 옵셔널 바인딩 하는곳
                        if let responseMessage = self.showAlert.message, let responeSignToken = self.showAlert.signin_token  {
                            
                            self.userCheckStatus = responseMessage
                            self.userSignToken = responeSignToken
                        }
                        
                     
                        print("디바이스 정보 확인 : \(UIDevice.current.model)/\(UIDevice.current.name)/Apple")
                        print("디바이스 id 확인 : \(String(describing: UIDevice.current.identifierForVendor!))")
                        // 로그인을 진행하는 함수
                        self.userJoinCheckStatus = "이미 가입된 회원입니다"
                        // 알러창에 띄울 텍스트
                        self.showAlertText = "이미 가입된 이메일입니다"
                        self.statusJoin.toggle()
                        
                    } else { // 이메일 형식이 다른경우
                        print("이메일을 확인해주세요")
                        self.showAlert = $0
                        // 알러창에 띄울 텍스트
                        self.userJoinCheckStatus = "이메일을 확인해주세요."
               
                        self.statusJoin.toggle()
                        
                        
                    }
                    
                  })
    }


    func loginViewClose(){
        self.boolLoginStatus.toggle()
        self.boolLoginStatus = true
    }
    
    // 액세스 토큰 가져오는 함수
    func getAccesToken(){
        accessToken = loginRespone.accessToken!
        DataBindingLog(from: "loginViewModel --> getAccessToken", data: "\(String(describing: loginRespone.accessToken!))")

    }
    // 서버에 이미지 업로드 하는 함수
    func imageUpload(paramName: String, fileName: String, image: UIImage){
        let url = URL(string: "")

         // 바운더리 문자열 생성
         let boundary = UUID().uuidString
         let session = URLSession.shared

         // url리퀘스트 오브젝트 생성하기
         var urlRequest = URLRequest(url: url!)
         urlRequest.httpMethod = "POST"

         // 헤더 설정하기
         urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

         var data = Data()
         // 이미지 데이터 + 바운더리 생성
         data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
         data.append("Content-Disposition: form-data; type=\"user\"\r\n".data(using: .utf8)!)
         data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
         data.append(image.pngData()!)
         data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

         // url session을 통해서 서버로 이미지 파일 보내주기
         session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
             if error == nil {
                 let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                 if let json = jsonData as? [String: Any] {
                     print(json)
                 }
             }
         }).resume()
    }

    
}

