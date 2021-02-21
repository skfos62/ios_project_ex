//
//  ViewStyles.swift
//  ios-shopping-mall
//
//  Created by 정나래 on 2020/11/10.
//

import SwiftUI

// MARK: 뷰에서 사용되는 모든 스타일을 선언한곳

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

var alert: Alert {
        Alert(title: Text("iOScreator"), message: Text("Hello SwiftUI"), dismissButton: .default(Text("Dismiss")))
    }

// MARK: --- padding 관련
// 전체 컨텐츠를 감싸는 stack에 주어야 하는 padding값
struct wrapStackPadding: ViewModifier {
    func body(content: Content) -> some View {
            content
                .padding([.leading,.trailing],20)
        }
}


// MARK: --- text 관련
struct TextStyles: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
        }
}
// title 텍스트
struct titleStyles: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
        }
}

// subtitle 텍스트 (title 밑에 설명 텍스트)
struct subTitleText: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 16, weight:.regular))
                .foregroundColor(Color(UIColor(named: "lightGrayText")!))
        }
}

// content gray 텍스트 (글내용이나 리스트에 들어가는 회색 텍스트)
struct ContentText: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 14, weight:.regular))
                .foregroundColor(Color(UIColor(named: "lightGrayText")!))
        }
}

// content black 텍스트 (글내용이나 리스트에 들어가는 검정색 텍스트)
// 다크모드 설정 완료한 텍스트 색상
struct ContentBlackText: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 14, weight:.regular))
                .foregroundColor(Color(UIColor(named: "blackText")!))
        }
}


// small 텍스트 (작은 회색 글씨를 표시할때 사용하는 텍스트)
struct smallText: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 12, weight:.regular))
                .foregroundColor(Color(UIColor(named: "lightGrayText")!))
        }
}

// small 텍스트 (작은 회색 글씨를 표시할때 사용하는 텍스트)
struct SmallBlackText: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 13, weight:.regular))
                .foregroundColor(Color(UIColor(named: "blackText")!))
        }
}


// MARK: --- (radius) tag &  button 관련

// 검은색 라인 버튼
struct BlackLineRadiusBtn: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 15, weight: .regular))
                .padding([.leading,.trailing], 8)
                .padding([.top,.bottom],5)
                .foregroundColor(Color(UIColor(named: "blackText")!))
                .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(UIColor(named: "blackText")!), lineWidth: 2)
                        )
                .cornerRadius(30)
        }
}

// 회색라인 버튼
struct GrayLineRadiusBtn: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 15, weight: .regular))
                .padding([.leading,.trailing], 8)
                .padding([.top,.bottom],5)
                .foregroundColor(Color(UIColor(named: "blackText")!))
                .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(UIColor(named: "grayText")!), lineWidth: 2)
                        )
                .cornerRadius(30)
        }
}

// 밝은 회색 라인 버튼
struct LightGrayLineRadiusBtn: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 15, weight: .regular))
                .padding([.leading,.trailing], 8)
                .padding([.top,.bottom],5)
                .foregroundColor(Color(UIColor(named: "blackText")!))
                .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(UIColor(named: "veryLightGray")!), lineWidth: 2)
                        )
                .cornerRadius(30)
        }
}

// 검은색 버튼
struct BlackRadiusBtn: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 15, weight: .regular))
                .padding([.leading,.trailing], 8)
                .padding([.top,.bottom],5)
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(30)
        }
}




extension View {
    // TODO: extenstion 할때 view modifier와 꼭 이름이 달라야한다
    //       여기서 extension 해놓으면 다른 뷰에서도 사용가능함
    
    // --- 텍스트 관련 스타일
    // title 텍스트 스타일
       func titleText() -> some View {
             self.modifier(titleStyles())
         }
    // subtitle 텍스트 스타일
       func subtitleText() -> some View {
             self.modifier(subTitleText())
         }
    // content 텍스트 스타일
       func contentText() -> some View {
             self.modifier(ContentText())
         }
    // content black  텍스트 스타일
       func contentBlackText() -> some View {
             self.modifier(ContentBlackText())
         }
    // small 텍스트 스타일
       func smallgrayText() -> some View {
             self.modifier(smallText())
         }
    // small black 텍스트 스타일
       func smallBlackText() -> some View {
             self.modifier(SmallBlackText())
         }
    
    // --- padding 관련
    // 전체 컨텐츠를 감싸는 stack의 padding
       func stackPadding() -> some View {
             self.modifier(wrapStackPadding())
         }
    
    // --- tag& button 관련
    
    // 검은색 라인 버튼
        func blackLineRadiusBtn() -> some View {
              self.modifier(BlackLineRadiusBtn())
          }
    // 회색 라인 버튼
        func grayLineRadiusBtn() -> some View {
              self.modifier(GrayLineRadiusBtn())
          }
    // 회색 라인 버튼
        func lightGrayLineRadiusBtn() -> some View {
              self.modifier(LightGrayLineRadiusBtn())
          }
    // 검은색 버튼
        func blackRadiusBtn() -> some View {
              self.modifier(BlackRadiusBtn())
          }
    
}
