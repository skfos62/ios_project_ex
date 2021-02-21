//
//  APIClient.swift
//  ios-shopping-mall
//
//  Created by 정나래 on 2020/11/18.
//

import Foundation
import Combine

struct APIClient {
    var statusCode = ""
    
    // 일반적으로 서버통신할때 사용하는 기본 통신 코드, 모든 api 파일은 이 구조체를 사용함.
    // value : 객체
    // response : 상태코드를 포함하는 url 응답
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder())  -> AnyPublisher<Response<T>, Error> {
        

        // GET, POST 또는 무엇이든 관계없이 네트워크 요청에 대한 진입점
        return URLSession.shared
            // URLSession published 로 바꿈
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                
                // 네트워크 요청 받은 response 결과를 일반 유형(사용자가 정의한)으로 디코딩
                let value = try decoder.decode(T.self, from: result.data)
                // http status code를 확인하는 곳
                if let httpResponse = result.response as? HTTPURLResponse {
                    print("http status Code: \(httpResponse.statusCode)")
                    Responselog(data: result.data, response: httpResponse)

                    // 통신 응답 코드 확인
                    switch httpResponse.statusCode {
                    case 200:
                        print("http status Code: 201 -- 새로운 컨텐츠 만들기 성공")
                    case 201:
                        print("http status Code: 201 -- 새로운 컨텐츠 만들기 성공")
                    case 204:
                        print("http status Code: 204 -- 성공했지만 응답할 콘텐츠가 없음")
                    case 206:
                        print("http status Code: 206 -- 스트리밍 경우같이 요청에 대한 응답을 일부만 먼저 전송")
                    case 400:
                        print("http status Code: 400 -- 서버가 요청을 이해하지 못할경우 , 유효성 검사 통과 실패")
                    case 401:
                        print("http status Code: 401 -- 권한이 없음")
                    case 403:
                        print("http status Code: 403 -- 금지된 페이지 : 관리자페이지(로긴을 하던말던 접근금지)")
                    case 404:
                        print("http status Code: 404 -- 찾을수 없는 페이지 ( 403일경우도 404로 보내는경우가 있음 위장으로)")
                    case 405:
                        print("http status Code: 405 -- http method 를 찾을수 없음")
                    case 408:
                        print("http status Code: 408 -- 요청 시간 초과")
                    case 409:
                        print("http status Code: 409 -- 서버가 요청을 처리하는 과정에서 충돌이 발생 ( ex. 회원가입을 했는데 이미 사용하고 있는 아이디 )")
                    case 410:
                        print("http status Code: 410 -- 영구적으로 사용할수 없는 페이지")
                    case 429:
                        print("http status Code: 429 -- 사용자가 지정된 시간에 너무 많은 요청을 보냄")
                    case 451:
                        print("http status Code: 451 -- 법적으로 막힌 페이지")
                    case 500:
                        print("http status Code: 500 -- 내부 서버 에러 (요청은 정상이나 서버내부 에러 )")
                    case 501:
                        print("http status Code: 501 -- 서버에 아직 해당 요청을 처리하는 기능을 만들지 않았다")
                    case 502:
                        print("http status Code: 502 -- 서버로 가는 요청이 중간에서 유실된 경우")
                    case 503:
                        print("http status Code: 503 -- 서버가 터짐(접속폭주 또는 디도스 ) 유지보수중일때 전송.")
                    case 504:
                        print("http status Code: 504 -- 서버 게이트웨이에 문제가 생겨 시간 초과")
                    case 505:
                        print("http status Code: 505 -- http 버전이 달라 요청을 처리할 수 없음")
                    
                    default:
                        print("http status Code: 없는 코드")
                    }

                }

                // 디코딩한 response객체는 실제 데이터 + 상태코드와 합쳐진 형태로 리턴함
                return Response(value: value, response: result.response)
            }
            // 메인 스레드에 결과 반환
            .receive(on: DispatchQueue.main)
            // 지금까지의 데이터 스트림의 형태가 어떠하든 최종적으로는 Publisher형태로 반환
            .eraseToAnyPublisher()
    }
}
