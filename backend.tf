terraform {
  backend "s3" {
    bucket = "tf-projectname"
    key    = "demo"
    region = "us-west-2"
  }
}
