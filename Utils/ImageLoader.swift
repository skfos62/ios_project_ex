//
//  ImageLoader.swift
//  ios-shopping-mall
//
//  Created by 정나래 on 2020/12/14.
//

import SwiftUI

class ImageLoader {
    
}

// 서버에서 받아오는 imageurl을 사용할수있게 만들어주는 extention
extension String {
    func load() -> UIImage {
        do {
            // string을 url객체로 변환하는곳
            guard let url = URL(string: self) else {
                // 빈 이미지일 경우 url
                return UIImage()
            }
            // url을 데이터로 변환
            let data:Data = try Data(contentsOf: url)
            
            // uiimage 오브젝트 생성
            // 옵셔널 value일경우는 그냥 이미지 사용
            return UIImage(data: data) ?? UIImage()
            
        } catch {
            
        }
        return UIImage()
    }
}


