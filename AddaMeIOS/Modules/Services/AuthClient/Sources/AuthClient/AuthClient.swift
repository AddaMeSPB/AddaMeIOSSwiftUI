import Combine
import Foundation
import FuncNetworking
import AddaMeModels

public struct AuthClient {
  
  public typealias LoginHandler = (AuthResponse) -> AnyPublisher<AuthResponse, HTTPError>
  public typealias VarificationHandler = (AuthResponse) -> AnyPublisher<LoginRes, HTTPError>
  
  public var login: LoginHandler
  public var varification: VarificationHandler
  
  public init(
    login: @escaping LoginHandler,
    varification: @escaping VarificationHandler
  ) {
    self.login = login
    self.varification = varification
  }
  
}
