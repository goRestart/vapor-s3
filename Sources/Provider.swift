import Vapor
import S3SignerAWS

private struct ConfigKeys {
  static let s3 = "s3"
  static let accessKey = "accessKey"
  static let secretKey = "secretKey"
  static let bucket = "bucket"
  static let region = "region"
}

extension S3: ConfigInitializable {
  
  public init(config: Config) throws {
    guard let s3Config = config[ConfigKeys.s3] else {
      throw ConfigError.missingFile(ConfigKeys.s3)
    }
    guard let accessKey = s3Config[ConfigKeys.accessKey]?.string else {
      throw ConfigError.missing(key: [ConfigKeys.accessKey], file: ConfigKeys.s3, desiredType: String.self)
    }
    guard let secretKey = s3Config[ConfigKeys.secretKey]?.string else {
      throw ConfigError.missing(key: [ConfigKeys.secretKey], file: ConfigKeys.s3, desiredType: String.self)
    }
    guard let bucket = s3Config[ConfigKeys.bucket]?.string else {
      throw ConfigError.missing(key: [ConfigKeys.bucket], file: ConfigKeys.s3, desiredType: String.self)
    }
    guard let configRegion = s3Config[ConfigKeys.region]?.string,
      let defaultRegion = Region(rawValue: configRegion) else {
        throw ConfigError.missing(key: [ConfigKeys.region], file: ConfigKeys.s3, desiredType: String.self)
    }

    let configuration = Configuration(
      bucket: bucket,
      region: defaultRegion.rawValue
    )
    
    let signer = S3SignerAWS(
      accessKey: accessKey,
      secretKey: secretKey,
      region: defaultRegion
    )
    
    let requestBuilder = S3RequestBuilder(
      configuration: configuration,
      signer: signer
    )
    let client = try config.resolveClient()
    
    self.init(
      requestBuilder: requestBuilder,
      client: client
    )
  }
}
