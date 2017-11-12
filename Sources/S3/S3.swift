import Foundation
import HTTP
import Vapor

public enum S3Error: Error {
  case invalidBucket
  case invalidResponse(Response)
  case notFound
  case noContent
}

public struct S3 {
 
  private let requestBuilder: S3RequestBuilder
  private let client: ClientFactoryProtocol
  
  public init(requestBuilder: S3RequestBuilder,
              client: ClientFactoryProtocol)
  {
    self.requestBuilder = requestBuilder
    self.client = client
  }
  
  public func get(destinationPath: String) throws -> Bytes {
    let request = try requestBuilder.build(.get, .none, destinationPath)
    let result = try client.get(request.url, query: [:], request.headers)
    
    guard [.ok, .continue].contains(result.status) else {
      throw S3Error.invalidResponse(result.makeResponse())
    }
    guard let content = result.body.bytes else {
      throw S3Error.noContent
    }
    return content
  }
  
  public func put(_ bytes: Bytes, destinationPath: String, acl: ACL) throws -> S3Response {
    let request = try requestBuilder.build(.put, .bytes(bytes), destinationPath, acl)
    let result = try client.put(request.url, request.headers, Body(bytes))
    
    guard [.ok, .continue].contains(result.status) else {
      throw S3Error.invalidResponse(result.makeResponse())
    }
    return S3Response(url: request.url)
  }
  
  public func delete(destinationPath: String) throws {
    let request = try requestBuilder.build(.delete, .none, destinationPath)
    let result = try client.delete(request.url, query: [:], request.headers)
    
    guard [.ok, .noContent].contains(result.status) else {
      throw S3Error.invalidResponse(result.makeResponse())
    }
  }
}
