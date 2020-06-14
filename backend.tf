terraform {
  backend "s3" {
    bucket = "tf-remotestate-s3demo"
    key    = "tfstate"
    region = "us-west-2"
  }
}
