//
//  TextStyles.swift
//  ios-shopping-mall
//
//  Created by 정나래 on 2020/11/10.
//

import SwiftUI

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

// content 텍스트 (글내용이나 리스트에 들어가는 텍스트)
struct ContentText: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 14, weight:.regular))
                .foregroundColor(Color(UIColor(named: "lightGrayText")!))
        }
}


// small 텍스트 (작은 글씨를 표시할때 사용하는 텍스트)
struct smallText: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 12, weight:.regular))
                .foregroundColor(Color(UIColor(named: "lightGrayText")!))
        }
}
