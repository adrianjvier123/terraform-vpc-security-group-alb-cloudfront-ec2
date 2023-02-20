# Creating new S3 bucket whitout cloudfront
resource "aws_s3_bucket_website_configuration" "wp_static" {
  bucket = var.bucket_wp_name

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error/index.html"
  }
}
resource "aws_s3_bucket" "my_bucket_static" {

  bucket = var.bucket_wp_name  #Enter unique name here
  tags = {
    Name        = "My bucket"
  }
}

# Bucket Policy for allowing acess to cloudfront distribution
resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket_static.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.my_bucket_static.bucket}/*"
            ]
        }
    ]
}
POLICY
}

# Storing Objects in S3 bucket 
# resource "aws_s3_bucket_object" "object" {
#   acl = "public-read"
#   depends_on = [aws_s3_bucket.my_bucket]
#   bucket = aws_s3_bucket.my_bucket.id
#   key    = "WALLPAPER.jpg"
#   source = "./images/WALLPAPER2.jpg"   # Provide exact path of your file
# }

resource "null_resource" "remove_and_upload_to_s3_2" {
  provisioner "local-exec" {
    command = "aws s3 sync ../modules/s3/static-website-example-master/ s3://${aws_s3_bucket.my_bucket_static.id}"
  }
}


resource "aws_s3_bucket" "b" {
  bucket = "pruebbabuckerjavtest"

  tags = {
    Name = "My bucket"
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

locals {
  s3_origin_id = aws_s3_bucket.b.bucket_domain_name
}
resource "aws_cloudfront_origin_access_control" "example" {
  name                              = "example"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.b.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.example.id
    origin_id                = aws_s3_bucket.b.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.b.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "CO" ]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Bucket Policy for allowing acess to cloudfront distribution
resource "aws_s3_bucket_policy" "my_bucket_policy_b" {
  bucket = aws_s3_bucket.b.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipalReadOnly",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.b.bucket}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${aws_cloudfront_distribution.s3_distribution.arn}"
                }
            }
        }
    ]
}
POLICY
}


resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ../modules/s3/static-website-example-master/ s3://${aws_s3_bucket.b.id}"
  }
}