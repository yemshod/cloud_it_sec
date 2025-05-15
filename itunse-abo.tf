resource "aws_s3_bucket_policy" "central_logs" {
  bucket = aws_s3_bucket.central_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = concat(
      [
        {
          Sid       = "AWSCloudTrailGetBucketAcl"
          Effect    = "Allow"
          Principal = { Service = "cloudtrail.amazonaws.com" }
          Action    = "s3:GetBucketAcl"
          Resource  = "arn:aws:s3:::${var.log_bucket_name}"
          Condition = {
            StringEquals = {
              "aws:SourceArn" = flatten([
                for acc, regions in var.account_region_map :
                [for region in regions :
                  "arn:aws:cloudtrail:${region}:${acc}:trail/*"
                ]
              ])
            }
          }
        }
      ],
      flatten([
        for acc, regions in var.account_region_map : [
          for region in regions : {
            Sid       = "AWSCloudTrailWrite20150319-${acc}-${region}"
            Effect    = "Allow"
            Principal = { Service = "cloudtrail.amazonaws.com" }
            Action    = "s3:PutObject"
            Resource  = "arn:aws:s3:::${var.log_bucket_name}/AWSLogs/${acc}/*"
            Condition = {
              StringEquals = {
                "s3:x-amz-acl"   = "bucket-owner-full-control",
                "aws:SourceArn" = "arn:aws:cloudtrail:${region}:${acc}:trail/*"
              }
            }
          }
        ]
      ])
    )
  })
}
