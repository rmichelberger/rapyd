//
//  Network.swift
//  rapyd
//
//  Created by Roland Michelberger on 01.06.21.
//

import Foundation

final class Network {
    
    static var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.timeoutIntervalForResource = TimeInterval(60)
        return URLSession(configuration: configuration)
    }()
    
    enum Environment {
        case local, test, staging, prod
    }
    
    #if DEBUG
    
    private static let environment = Environment.test
    
    #else
    
    private static let environment = Environment.staging
    
    #endif
    
    private static var components: URLComponents {
        switch environment {
        case .local:
            return URLComponents(string: "http://localhost:5001/rapyd-pay/us-central1")!
        case .test:
            return URLComponents(string: "https://us-central1-rapyd-pay.cloudfunctions.net")!
        case .staging:
            return URLComponents(string: "https://us-central1-rapyd-pay.cloudfunctions.net")!
        case .prod:
            return URLComponents(string: "https://us-central1-rapyd-pay.cloudfunctions.net")!
        }
    }
    
    class func url(path: String, queryItems: [URLQueryItem]? = nil) -> URL {
        var components = self.components
        components.path += path
        components.queryItems = queryItems
        
        return components.url!
        //        URL(string: host)!.appendingPathComponent(path)
    }
    
    class func addJSONHeader(request: inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    class func post<B: Codable, T: Codable>(url: URL, body: B, encoder: JSONEncoder = .encoder, decoder: JSONDecoder = .decoder, headers: [Header] = [], completion: @escaping (Result<T, Error>) -> Void) {
        call(url: url, method: .post, body: body, encoder: encoder, decoder: decoder, headers: headers, completion: completion)
    }
    
    class func delete<B: Codable, T: Codable>(url: URL, body: B, encoder: JSONEncoder = .encoder, decoder: JSONDecoder = .decoder, headers: [Header] = [], completion: @escaping (Result<T, Error>) -> Void) {
        call(url: url, method: .delete, body: body, encoder: encoder, decoder: decoder, headers: headers, completion: completion)
    }
    
    private enum HTTPMethod: String {
        case post, delete
    }
    
    private class func call<B: Codable, T: Codable>(url: URL, method: HTTPMethod, body: B, encoder: JSONEncoder, decoder: JSONDecoder, headers: [Header], completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        do {
            request.httpMethod = method.rawValue.uppercased()
            if B.self is Empty.Type {
            } else {
                let data = try encoder.encode(body)
                request.httpBody = data
            }
            
            addJSONHeader(request: &request)
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.name)
            }
            
            #if DEBUG
            log(request: request)
            #endif
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                handleResponse(data: data, response: response, error: error, completion: completion)
            }
            task.resume()
            
        } catch {
            completion(.failure(error))
        }
    }
    
    class func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let request = URLRequest(url: url)
        
        
        #if DEBUG
        log(request: request)
        #endif
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            #if DEBUG
            log(response: response, body: data)
            #endif
            
            if let error = error {
                completion(.failure(error))
            } else if isStatusCodeOk(status: response?.status) {
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(NetworkError.missingResponseBody))
                }
            } else if let status = response?.status {
                completion(.failure(NetworkError.serverError(status)))
            } else {
                completion(.failure(NetworkError.unknown))
            }
        }
        task.resume()
    }
    
    class func get<T: Codable>(url: URL, decoder: JSONDecoder = .decoder, completion: @escaping (Result<T, Error>) -> Void) {
        
        var request = URLRequest(url: url)
        addJSONHeader(request: &request)
        
        
        #if DEBUG
        log(request: request)
        #endif
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    private class func handleResponse<T: Codable>(decoder: JSONDecoder = .decoder, data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T, Error>) -> Void) {
        #if DEBUG
        log(response: response, body: data)
        #endif
        if let error = error {
            completion(.failure(error))
        } else if isStatusCodeOk(status: response?.status) {
            if T.self is Empty.Type {
                completion(.success(Empty() as! T))
            } else if let data = data {
                if T.self is String.Type, let string = String(data: data, encoding: .utf8) {
                    completion(.success(string as! T))
                } else {
                    do {
                        let t = try decoder.decode(T.self, from: data)
                        completion(.success(t))
                    } catch {
                        completion(.failure(error))
                    }
                }
            } else {
                completion(.failure(NetworkError.missingResponseBody))
            }
        } else if let status = response?.status {
            completion(.failure(NetworkError.serverError(status)))
        } else {
            completion(.failure(NetworkError.unknown))
        }
    }
    
    class private func isStatusCodeOk(status: Int?) -> Bool {
        guard let status = status else {
            return false
        }
        switch status {
        case 200..<300:
            return true
        default:
            return false
        }
    }
    
    enum NetworkError: Error {
        case unknown, serverError(Int), missingResponseBody
    }
    
    struct Empty: Codable { }
    
    
    struct Header {
        let name: String
        let value: String
    }
    
    
    #if DEBUG
    
    private class func log(request: URLRequest) {
        debugLog("request", request.cURL(pretty: true))
    }
    
    private class func log(response: URLResponse?, body: Data?) {
        if let response = response {
            debugLog("response", response)
        } else {
            debugLog("No response")
        }
        if let body = body {
            if let string = String(data: body, encoding: .utf8) {
                debugLog(string)
            } else {
                debugLog(body)
            }
        } else {
            debugLog("No body")
        }
    }
    
    #endif
    
}


#if DEBUG

extension URLRequest {
    public func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        
        var cURL = "curl "
        var header = ""
        var data: String = ""
        
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        cURL += method + url + header + data
        
        return cURL
    }
}

#endif


extension URL {
    
    var components: (url: URL, queryItems:[URLQueryItem]) {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return (url: self, queryItems:[])
        }
        let queryItems = urlComponents.queryItems ?? []
        urlComponents.queryItems = nil
        let url = urlComponents.url ?? self
        return (url: url, queryItems:queryItems)
    }
    
}

/*
 extension Data {
 mutating func append(string: String) {
 guard let data = string.data(using: .utf8, allowLossyConversion: true) else { return }
 append(data)
 }
 }
 */
