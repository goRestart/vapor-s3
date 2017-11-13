import Foundation
import Vapor
import HTTP
import S3SignerAWS

public struct S3RequestBuilder {
  
  private let amazonS3AwsDomain = ".s3.amazonaws.com"
  
  private let configuration: Configuration
  private let signer: S3SignerAWS
  
  init(configuration: Configuration,
       signer: S3SignerAWS)
  {
    self.configuration = configuration
    self.signer = signer
  }
  
  func build(_ httpMethod: HTTPMethod, _ payload: Payload, _ destinationPath: String, _ acl: ACL? = nil) throws -> (originalUrl: String, url: String, headers: [HeaderKey: String]) {
    guard let baseUrl = URL(string: "https://\(configuration.bucket)") else {
      throw S3Error.invalidBucket
    }
    let url = ("\(baseUrl.absoluteString)\(amazonS3AwsDomain)\(destinationPath)")
    
    var awsHeaders = [String: String]()
    if httpMethod == .put {
      awsHeaders[HeaderKey.expect.key] = "100-continue"
    }
    if let acl = acl {
      awsHeaders[HeaderKey.awsAcl.key] = acl.rawValue
    }
    
    let signedHeaders = try signer.authHeaderV4(
      httpMethod: httpMethod,
      urlString: url,
      headers: awsHeaders,
      payload: payload
    )
    let originalUrl = baseUrl.appendingPathComponent(destinationPath).absoluteString
    return (originalUrl: originalUrl, url: url, make(signedHeaders))
  }
  
  private func make(_ headers: [String: String]) -> [HeaderKey: String] {
    return headers.reduce([:]) { (newHeaders, header: (key: String, value: String)) in
      var derived = newHeaders
      derived[HeaderKey(header.key)] = header.value
      return derived
    }
  }
}

extension HeaderKey {
  static public var awsAcl: HeaderKey {
    return HeaderKey("x-amz-acl")
  }
}
