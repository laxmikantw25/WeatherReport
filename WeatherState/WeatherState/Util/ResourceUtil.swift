//
//  ResourceUtil.swift
//  WeatherState
//
//  Created by SDB01 on 28/12/19.
//

import Foundation

class ResourceUtil: NSObject {
    
    static func prepareRequestUrl(apiEndpoint: String) -> URL? {
        return prepareRequestUrl(dictType: "endPoint", apiEndpoint: apiEndpoint)
    }
    
    private static func prepareRequestUrl(dictType: String, apiEndpoint: String?) -> URL?{
        var requestUrl: URL?
        if let path = Bundle.main.path(forResource: getPlistForEnv(), ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            
            guard var endpointString = dict[dictType] as? String else {
                return requestUrl
            }
            endpointString = endpointString.appending(apiEndpoint!)
            requestUrl = URL(string: endpointString)
        }
        return requestUrl
    }
    
    private static func getPlistForEnv() -> String{
        return prodBackendDetails
    }
}
