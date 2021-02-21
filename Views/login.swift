//
//  login.swift
//  ios-shopping-mall
//
//  Created by 정나래 on 2020/10/14.
//
//  MARK: --- 로그인 페이지

import SwiftUI

struct login: View {
    @Binding var isPresented:Bool
    // @state 변화를 감지하는것
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @State var showDetails = false
    // 사용자들이 잘못된 정보를 입력했는지 체크하는 bool
    @State var authDidFail : Bool = false
    //로그인 뷰모델
    @ObservedObject var loginVm:LogInViewModel
    // 로그인 확인하는
    @State var showAlertView = false
    // 로그인 상태 확인하는 변수
    @State var stateLogin:String
    @Binding var loginStateCheck:Bool
    // 내정보에 전달할 값 --
    @Binding var profileNickname:String
    @Binding var profileImageURL:String
    @Binding var profileEmail:String
    // 회원가입하는 뷰를 띄우는 함수
    @State var showSignUp: Bool = false
    @State var showSignUpStep1: Bool = false
    // 로그인 확인후 진행하는 함수
    @State var loginClose:Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // 로그인 상태를 전달하는 클로저
    var loginSatusCloser: (Bool)-> ()
    // 유저 상태를 전달하는 클로저
    var UserInfoCloser: ([String])-> ()
    @ObservedObject var JoinVm:JoinViewModel
    
    var body: some View {
        ZStack{
            ZStack(alignment: .bottomTrailing){
                /**
                 <로그인했을때 viewmodel을 이용해서 다음 view에 데이터 전달하기>
                 1. 뷰모델 클래스를 생성해서 사용자들이 입력한 값이 viewmodel클래스에 저장되게 한다.
                 2. viewmodel 값에 전달된 데이터 값을 다음 view에 텍스트에서 표시되게 하r기
                 */
                VStack{
                    // 상단 네비게이션 뷰ㅋ
                    TopNavigationView(titleText: "로그인")
                    ScrollView {

                        // alignment : .leading -> 왼쪽정렬
                        // VStack -> 뷰를 수직으로 쌓는 stack (세로)
                        // HStack -> 뷰를 수평으로 쌓는 stack (가로)
                        VStack (alignment:.leading) {
                            // 이메일 입력
                            emailSection()
                            emailField(userEmail: $loginVm.userName)
                            // 비밀번호 입력
                            passwordSection()
                            passwordField(userPassword: $loginVm.userPassword)
                            // 로그인 버튼과 소셜 버튼
                            Button(action: {

                                loginVm.userCheck()


                            }, label: {
                                loginBtn()
                            })

                            .alert(isPresented: $loginVm.statusJoin) { () -> Alert in
                                return  Alert(title: Text("알림"),
                                              message: Text(loginVm.showAlertText),
                                              dismissButton: Alert.Button.default(
                                                Text("확인"), action: {
                                                    if loginVm.modalStatus == "로그인창닫기" {
                                                        self.presentationMode.wrappedValue.dismiss()
                                                    } else {
                                                        print("로그인 실패 ")
                                                    }
                                                }
                                              ))
                            }

                            // 회원가입하기
                            Button(action: {
                                self.showSignUp.toggle()
                            }) {
                                HStack{
                                    Spacer()
                                    Text("회원가입하기")
                                }

                            }

                        }


                        if authDidFail {
                            Text("정보를 다시 입력해주세요")
                                .offset(y:10)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        }
                        // 소셜 로그인
                        Text("간편 로그인")
                            .fontWeight(.black)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(.top, 90)
                            .padding(.bottom, 10)
                        
                        gooleLoginBtn()
                        githubLoginBtn()
                        
                    } // Vstack
                    .padding(30)
                    .frame(maxHeight: .infinity)
                    

                } // scrollView

            }
            .foregroundColor(.black)
            .navigationBarTitle("로그인",displayMode: .inline)
            

            
            if showSignUp {
                TermsOfService(JoinVm: JoinVm, loginVm: loginVm)
                    .transition(AnyTransition.move(edge: .trailing))
                
            }
            
        } // Zstack
        .animation(Animation.spring())
        .padding(.top,50)
        .edgesIgnoringSafeArea(.all)
        .onDisappear(){
            // 로그인 완료후 완료됐다는 데이터를 tapmyinfopage에 전달하는 클로저
            // 여기서 if 문으로 로그인 됐는지 안됐는지 확인해야함
            if loginVm.loginRespone.accessToken == ""{
                self.loginSatusCloser(.init(false))
                self.UserInfoCloser(.init([loginVm.loginRespone.accessToken!,loginVm.loginRespone.user.profileNickname!]))
            } else {
                self.loginSatusCloser(.init(true))

                self.UserInfoCloser(.init([loginVm.loginRespone.accessToken ?? "" ,loginVm.loginRespone.user.profileNickname ?? ""]))

            }

        }
        
    }// 가장 바깥쪽에 있는 zstack

    
}


//  MARK: --- 사용된 구조체 선언부
struct loginPage_Previews: PreviewProvider {
    static var previews: some View {

        login(isPresented: .constant(false), stateLogin: "", loginStateCheck: .constant(false),profileNickname: .constant("dd"),profileImageURL:.constant("dd"), profileEmail: .constant("dd"), loginSatusCloser: true)
    }
}


// 이메일 작성 타이틀
struct emailSection: View  {
    var body: some View {
        Text("이메일")
            .fontWeight(.black) // 폰트 굵기 설정
            .multilineTextAlignment(.leading) // 정렬
            .padding(.bottom, 20)
            .padding(.top, 40)
        // 아래 여백
    }
}
// 이메일 작성 텍스트 필드
struct emailField: View {
    @Binding var userEmail: String

    var body: some View {
        TextField("이메일을 입력하세요" , text: $userEmail )
            .padding(20)
            .border(Color.black)

    }
}

// 비밀번호 작성 타이틀
struct passwordSection: View  {
    var body: some View {
        Text("비밀번호")
            .fontWeight(.black)
            .multilineTextAlignment(.leading)
            .padding([.bottom, .top], 20)
    }
}
// 비밀번호 작성 텍스트 피드
struct passwordField: View {
    @Binding var userPassword: String
    var body: some View {
        SecureField("비밀번호 입력하세요" , text: $userPassword )
            .padding(20)
            .border(Color.black)
    }
}


// 로그인 버튼
struct loginBtn: View {
    var body: some View {

        Text("로그인 하기")
            // 텍스트 배경의 색상
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .padding(.top,30)
    }
}
// 구글 소셜 로그인 버튼
struct gooleLoginBtn: View {
    var body: some View {
        // 구글 버튼을 감싸는 stack
        HStack{
            Image("googleIcon")
            Text("Sign in with google")
                // 텍스트 배경의 색상
                .font(.none)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(Color.white)
        .border(Color.black, width: 1)
    }
}


// 깃헙 소셜 로그인 버튼
struct githubLoginBtn: View {
    var body: some View {
        HStack{
            Image("githubIcon")
            Text("Sign in with GitHub")
                // 텍스트 배경의 색상
                .font(.none)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color.black)
        .border(Color.black, width: 1)
    }
    
}

