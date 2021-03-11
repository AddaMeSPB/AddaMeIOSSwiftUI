////
////  FuncNetworking.swift
////  AddaMeIOS
////
////  Created by Saroar Khandoker on 12.01.2021.
////
//
//import Foundation
//import Combine
//
//
//public struct API {
//  struct EndpointProvider {
//    let path: String
//    let queryItems: [URLQueryItem]
//  }
//
//  public enum Environment {
//    case debug
//    case production
//  }
//
//  typealias EndpointBuilder = (EndpointProvider) -> Endpoint
//  typealias HeadersBuilder = () -> Set<APIRequestHeaderField>
//
//  let headers: HeadersBuilder
//  let endpoint: EndpointBuilder
//}
//
//public struct Endpoint {
//  enum BuilderError: Error {
//    case invalidUrlStringInput(String)
//    case invalidHostFromComponents(URLComponents)
//  }
//  // Public
//  let host: String
//  let path: String
//  let scheme: String
//  let queryItems: [URLQueryItem]
//
//  // Initializer
//  public init(
//    host: String,
//    scheme: String = "https",
//    path: String = .init(),
//    queryItems: [URLQueryItem] = []
//  ) {
//    self.host = host
//    self.path = path
//    self.scheme = scheme
//    self.queryItems = queryItems
//  }
//
//  public init(urlString: String) throws {
//    guard let components = URLComponents(string: urlString) else {
//      throw BuilderError.invalidUrlStringInput(urlString)
//    }
//    guard let host = components.host else {
//      throw BuilderError.invalidHostFromComponents(components)
//    }
//
//    self.host = host
//    self.path = components.path
//    self.scheme = components.scheme ?? "http"
//    self.queryItems = components.queryItems ?? []
//  }
//}
//
//extension Endpoint {
//  public var url: URL? {
//    var components = URLComponents()
//    components.host = host
//    components.path = path
//    components.scheme = scheme
//    components.queryItems = queryItems
//
//    return components.url
//  }
//}
//
//public struct APIRequestHeaderField: Hashable {
//  var headers: [String: String]?
//}
//
//struct RequestBuilder {
//  public var baseURL: URL
//  public var method: HTTPRMethod
//  public var headers: [String: String]?
//  public let urlRequest: () -> URLRequest
//
//  func build(
//    baseURL: URL,
//    method: HTTPRMethod,
//    headers: [String : String]?
//  ) -> Self {
//
//    .init(baseURL: baseURL, method: method, headers: headers) { () -> URLRequest in
//      let builder: () -> URLRequest = {
//        switch method {
//        case .get:
//          var request = URLRequest(url: baseURL)
//
//          request.setupRequest(headers: headers, method: .get)
//
//          return request
//        case .post, .put, .patch:
//
//        case .delete:
//          <#code#>
//        }
//      }
//
//      return .init(url: url)
//    }
//  }
//}
//
//internal extension URLRequest {
//  private var headerField: String { "Authorization" }
//  private var contentTypeHeader: String { "Content-Type" }
//
//  mutating func setupRequest(
//    headers: [String: String]?,
//    authType: AuthType,
//    contentType: ContentType,
//    method: HTTPRMethod
//  ) {
//    let contentTypeHeaderName = contentTypeHeader
//    allHTTPHeaderFields = headers
//    setValue(contentType.content, forHTTPHeaderField: contentTypeHeaderName)
//    setupAuthorization(with: authType)
//    httpMethod = method.rawValue
//  }
//
//  mutating func setupAuthorization(with authType: AuthType) {
//    switch authType {
//    case .basic(let username, let password):
//      let loginString = String(format: "%@:%@", username, password)
//      guard let data = loginString.data(using: .utf8) else { return }
//      setValue("Basic \(data.base64EncodedString())", forHTTPHeaderField: headerField)
//    case .bearer(let token):
//      setValue("Bearer \(token)", forHTTPHeaderField: headerField)
//    case .none: break
//    }
//  }
//}
//
//extension URL {
//  func generateUrlWithQuery(with parameters: [String: Any]) -> URL {
//    var quearyItems: [URLQueryItem] = []
//    for parameter in parameters {
//      quearyItems.append(
//        URLQueryItem(
//          name: parameter.key,
//          value: parameter.value as? String
//        )
//      )
//    }
//    var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
//    urlComponents.queryItems = quearyItems
//    guard let url = urlComponents.url else { fatalError("Wrong URL Provided") }
//    return url
//  }
//}
//
////  struct RequestBuilder {
////    static func build(from: URL, input: Request<ResultType>.Input, method: HTTPMethod, headers: Set<APIRequestHeaderField>?) {
////      self.from = from
////      self.input = input
////      self.method = method
////      self.headers = headers
////    }
////
////    var from: URL
////    var input: Input
////    var method: HTTPMethod
////    var headers: Set<APIRequestHeaderField>?
////  }
//
//public struct Request<ResultType> {
//  public struct HttpError: Swift.Error {
//    var description: String
//
//    static func invalidEndpoint(_ endpoint: Endpoint) -> Self {
//      return .init(description: "Invalid endpoint \(endpoint)")
//    }
//  }
//
//  public let url: URL
//  public let urlRequest: URLRequest
//  public let method: HTTPRMethod
//  public let input: Input
//  public let output: Output<ResultType>
//  public let logResponse: Bool
//
//  init(
//    endpoint: Endpoint,
//    method: HTTPRMethod,
//    input: Input,
//    output: Output<ResultType>,
//    logResponse: Bool = false
//  ) throws {
//    guard let url = endpoint.url else {
//      throw HttpError.invalidEndpoint(endpoint)
//    }
//
////    self.urlRequest = RequestBuilder.build(from: url, input: input, method: method, headers: input.headers)
//
//    self.urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: .zero)
//
//    self.url = url
//    self.method = method
//    self.input = input
//    self.output = output
//    self.logResponse = logResponse
//  }
//
//}
//
//// Input
//extension Request {
//  public struct Input {
//    let data: Data?
//    let headers: Set<APIRequestHeaderField>?
//
//    public init(
//      data: Data?,
//      headers: Set<APIRequestHeaderField>?
//    ) {
//      self.data = data
//      self.headers = headers
//    }
//
//    public static var none: Request.Input {
//      .init(data: nil, headers: nil)
//    }
//
//    public static func empty(headers: Set<APIRequestHeaderField>) -> Request.Input {
//      .init(data: nil, headers: headers)
//    }
//  }
//}
//
//
//// Output
//extension Request {
//  public struct Output<ResultType> {
//    let result: (Data) throws -> ResultType
//
//    public static var none: Request.Output<Void> {
//      .init(result: { _ in })
//    }
//
//    public init(result: @escaping (Data) throws -> ResultType) {
//      self.result = result
//    }
//
//  }
//}
//
//extension Request.Output where ResultType: Decodable {
//  public static func json(_ decoder: JSONDecoder = .init()) -> Request.Output<ResultType> {
//    return Request.Output<ResultType> { data in
//      let model: ResultType = try decoder.decode(
//        ResultType.self,
//        from: data
//      )
//      return model
//    }
//  }
//}
//
//extension Request.Input {
//  public static func json<T: Encodable>(
//    _ data: T,
//    headers: Set<APIRequestHeaderField>,
//    encoder: JSONEncoder = .init()
//  ) -> Request.Input {
//    let encoded = try? encoder.encode(data)
//    return Request.Input(
//      data: encoded,
//      headers: headers
//    )
//  }
//}
//
////struct DataType<Input> {
////  var input: Input?
////
////  static func dic(input: [String: Any], encoder: JSONEncoder = .init()) -> DataType<[String: Any]> {
////    .init(input: input)
////  }
////}
////
////extension DataType where Input == Encodable {
////  static func encodable(data: Input, encoder: JSONEncoder) -> Self {
////    .init(input: data)
////  }
////}
////
////extension DataType where Input == Data {
////  static func data(data: Input) -> Self {
////    .init(input: data)
////  }
////}
//
////public struct ContentType: Equatable {
////  public var content: String
////
////  public static var json: Self {
////    .init(content: "application/json")
////  }
////
////  public static var urlFormEncoded: Self {
////    .init(content: "application/x-www-form-urlencoded")
////  }
////
////  public  static var multipartFormData: Self {
////    .init(content: "multipart/form-data")
////  }
////}
//
//extension Request {
//  @available(iOS 13, *)
//    public func perform(
//      session: URLSession = .shared
//    ) -> AnyPublisher<ResultType, Swift.Error> {
//      session
//        .dataTaskPublisher(for: urlRequest)
//        .map(\.data)
//        .tryMap(output.result)
//        .eraseToAnyPublisher()
//    }
//}
//
//extension Request where ResultType == EventResponse2 {
//  fileprivate static func events(
//    endpoint: API.EndpointBuilder,
//    headers: API.HeadersBuilder,
//    decoder: JSONDecoder = .init()
//  ) throws -> Request<ResultType> {
//    let provider: API.EndpointProvider = .init(
//      path: "/events", queryItems: []
//    )
//    let requestHeaders = headers()
//    return try .get(
//      endpoint: endpoint(provider),
//      output: .json(decoder),
//      headers: requestHeaders,
//      logResponse: true
//    )
//  }
//}
//
//extension Request {
//
//  static public func get(
//    endpoint: Endpoint,
//    output: Output<ResultType>,
//    headers: Set<APIRequestHeaderField>,
//    logResponse: Bool
//  ) throws -> Request<ResultType> {
//    // i am thinking now here
//    return
//  }
//}
//
//struct EventResponse2: Codable {
//  let id: String
//  let title: String
//}
//
//public enum HTTPRMethod: String {
//    case get
//    case post
//    case put
//    case patch
//    case delete
//}
////
////public enum AuthType2 {
////    case bearer(token: String)
////    case none
////}
////
////public struct Request {
////  public var baseURL: URL
////  public var method: HTTPRMethod
////  public var headers: [String: String]?
////  public var dataType: DataType
////  public var authType: AuthType2
////  public var pathPrefix: String
////  public var path: String
////  public var contentType: ContentType
////}
////
////extension Request {
////    var pathAppendedURL: URL {
////        var url = baseURL
////        url.appendPathComponent(path)
////        return url
////    }
////}
////
////public struct DataType<Input> {
////  public var input: Input?
////}
////
////extension DataType where Input == Encodable {
////  static func encodable(data: Input, encoder: JSONEncoder) -> Self {
////    .init(input: data)
////  }
////}
////
////extension DataType where Input == Data {
////  static func data(data: Input) -> Self {
////    .init(input: data)
////  }
////}
////
////public struct ContentType: Equatable {
////  public var content: String
////
////  static var json: Self {
////    .init(content: "application/json")
////  }
////
////  static var urlFormEncoded: Self {
////    .init(content: "application/x-www-form-urlencoded")
////  }
////
////  static var multipartFormData: Self {
////    .init(content: "multipart/form-data")
////  }
////}
