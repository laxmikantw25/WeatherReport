//
//  NetworkManager.swift
//  WeatherState
//
//  Created by SDB01 on 28/12/19.
//

import Foundation

import UIKit

typealias NetworkResponseCompletion = (_ data: Data?, _ isSuccess: Bool?, _ error: String?) -> Void

protocol NetworkManagerProtocol {
    func request(_ requestDetail: RequestDetail, completion: @escaping NetworkResponseCompletion)
}

enum NetworkManagerResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case internalServerError = "Internal Server Issues"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case urlRequestFailure = "Url request could not be build"
    case networkIssue = "Please check your network connection."
}

enum Result<String>{
    case success
    case failure(String)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private var dataTask: URLSessionDataTask?
    private var uploadTask: URLSessionUploadTask?
    
    private init () {}
    
    internal func request(_ requestDetail: RequestDetail, completion: @escaping NetworkResponseCompletion) {
        let session = URLSession.shared
        do {
            
            try buildRequest(from: requestDetail, completion: { urlRequest in
                
                guard let urlRequest = urlRequest else {
                    completion(nil, false, NetworkManagerResponse.urlRequestFailure.rawValue)
                    return
                }
                
                self.dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
                    
                    if error != nil {
                        completion(nil, false, NetworkManagerResponse.networkIssue.rawValue)
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse {
                        let result = self.handleNetworkResponse(response)
                        switch result {
                        case .success:
                            guard let responseData = data else {
                                completion(nil, false, NetworkManagerResponse.noData.rawValue)
                                return
                            }
                            completion(responseData, true, nil)
                        case .failure(let networkFailureError):
                            completion(nil, false, networkFailureError)
                        }
                    }
                })
                self.dataTask?.resume()
            })
        } catch  {
            print(error)
            completion(nil, false, NetworkManagerResponse.urlRequestFailure.rawValue)
        }
    }
    
    private func buildRequest(from requestDetail: RequestDetail, completion: @escaping (_ urlRequest: URLRequest?) -> Void) throws {
        
        var request = URLRequest(url: requestDetail.requestURL)
        request.httpMethod = requestDetail.httpMethod.rawValue
        completion(request)
    }
    
    func fetchData<T: Decodable>(urlString: String, completion: @escaping (T?, _ isSuccess: Bool, _ errorMessage: String?) -> Void) {
        
        let requestUrl =  ResourceUtil.prepareRequestUrl(apiEndpoint:urlString)
        let requestDetail = RequestDetail(httpMethod: HTTPMethod.get, requestURL: requestUrl!)
        request(requestDetail, completion: { data, isSuccess, errorMessage in
            if errorMessage != nil && isSuccess == false {
                print("Error Message: \(String(describing: errorMessage))")
                completion(nil, false, errorMessage)
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                completion(try decoder.decode(T.self, from: data),true,nil)
            } catch {
                print("Error Message: \(String(data: data, encoding: String.Encoding.utf8)! as String)")
                print(error.localizedDescription)
                completion(nil, false, error.localizedDescription)
            }
        })
    }
}

extension NetworkManager {
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401: return .failure("HTTP Response -\(response.statusCode) :" + NetworkManagerResponse.authenticationError.rawValue)
        case 402...499: return .failure("HTTP Response -\(response.statusCode) :" + NetworkManagerResponse.badRequest.rawValue)
        case 500...599: return .failure("HTTP Response -\(response.statusCode) :" + NetworkManagerResponse.internalServerError.rawValue)
        case 600: return .failure("HTTP Response -\(response.statusCode) :" + NetworkManagerResponse.outdated.rawValue)
        default: return .failure("HTTP Response -\(response.statusCode) :" + NetworkManagerResponse.failed.rawValue)
        }
    }
}
