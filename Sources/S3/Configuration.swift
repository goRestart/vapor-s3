import Foundation

public enum US: String {
  case east_1_Virginia = "us-east-1"
  case east_2_Ohio  = "us-east-2"
  case west_1_California = "us-west-1"
  case west_2_Oregon = "us-west-2"
}

public enum EU: String {
  case central_Frankfurt = "eu-central-1"
  case west_1_Ireland = "eu-west-1"
  case west_2_London = "eu-west-2"
}

public enum AsiaPacific: String {
  case north_east_1_Tokyo = "ap-northeast-1"
  case north_east_2_Seoul = "ap-northeast-2"
  case south_east_1_Singapore = "ap-southeast-1"
  case south_east_2_Sydney = "ap-southeast-2"
  case south_1_Mumbai = "ap-south-1"
}

public enum SouthAmerica: String {
  case east_1_SãoPaulo = "sa-east-1"
}

public enum AWSRegion {
  case us(US)
  case eu(EU)
  case asiaPacific(AsiaPacific)
  case southAmerica(SouthAmerica)
}

public enum ACL: String {
  case `private` = "private"
  case publicRead = "public-read"
  case publicReadWrite = "public-read-write"
  case awsExecRead = "aws-exec-read"
  case authenticatedRead = "authenticated-read"
  case bucketOwnerRead = "bucket-owner-read"
  case bucketOwnerFullControl = "bucket-owner-full-control"
}

public struct Configuration {
  public let bucket: String
  public let region: String
  public let acl: ACL = .private
}
