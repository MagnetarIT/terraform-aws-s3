<a href=https://magnetarconsulting.co.uk><img src="https://magnetarconsulting.co.uk/wp-content/uploads/2020/04/small-helping-you-innovate-magnetar.png" width="300"></a>


# terraform-aws-s3
Terraform (>= 0.12.0) module to create an S3 bucket

[![Build Status](https://dev.azure.com/MagnetarIT/terraform-aws-s3/_apis/build/status/MagnetarIT.terraform-aws-s3?branchName=master)](https://dev.azure.com/MagnetarIT/terraform-aws-s3/_build/latest?definitionId=14&branchName=master) ![Latest Release](https://img.shields.io/github/release/MagnetarIT/terraform-aws-s3.svg)


- [Intro](#Intro)
- [Example](#Example)
- [Inputs](#Inputs)
- [Outputs](#Outputs)
- [Support](#Support)
- [License](#License)

----

## Example
```hcl

provider "aws" {
  region = "eu-west-2"
}

module "s3" {
  source      = "git::https://github.com/MagnetarIT/terraform-aws-s3.git?ref=tags/0.2.0"
  namespace   = "mag"
  environment = "test"
  name        = "app"
  attributes  = ["images"]
}

```

----

## Intro
This module will create the following resources
- S3 bucket 

---

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| abort\_incomplete\_multipart\_upload\_days | Maximum time (in days) that you want to allow multipart uploads to remain in progress | `number` | `5` | no |
| acl | The canned ACL to apply. We recommend `private` to avoid exposing sensitive information | `string` | `"private"` | no |
| allow\_encrypted\_uploads\_only | Set to `true` to prevent uploads of unencrypted objects to S3 bucket | `bool` | `false` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| enable\_glacier\_transition | Enables the transition to AWS Glacier which can cause unnecessary costs for huge amount of small files | `bool` | `false` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | n/a | yes |
| expiration\_days | Number of days after which to expunge the objects | `number` | `90` | no |
| force\_destroy | A boolean string that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable | `bool` | `false` | no |
| glacier\_transition\_days | Number of days after which to move the data to the glacier storage tier | `number` | `60` | no |
| kms\_master\_key\_arn | The AWS KMS master key ARN used for the `SSE-KMS` encryption. This can only be used when you set the value of `sse_algorithm` as `aws:kms`. The default aws/s3 AWS KMS master key is used if this element is absent while the `sse_algorithm` is `aws:kms` | `string` | `""` | no |
| lifecycle\_rule\_enabled | Enable or disable lifecycle rule | `bool` | `false` | no |
| lifecycle\_tags | Tags filter. Used to manage object lifecycle events | `map(string)` | `{}` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | n/a | yes |
| namespace | Namespace, which could be your team, business name or abbreviation, e.g. 'mag' or 'tar' | `string` | n/a | yes |
| noncurrent\_version\_expiration\_days | Specifies when noncurrent object versions expire | `number` | `90` | no |
| noncurrent\_version\_transition\_days | Number of days to persist in the standard storage tier before moving to the glacier tier infrequent access tier | `number` | `30` | no |
| policy | A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy | `string` | `""` | no |
| prefix | Prefix identifying one or more objects to which the rule applies | `string` | `""` | no |
| region | If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee | `string` | `""` | no |
| s3\_actions | Actions to allow in the policy, default is read only | `list(string)` | <pre>[<br>  "s3:GetObject"<br>]</pre> | no |
| sse\_algorithm | The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms` | `string` | `"AES256"` | no |
| standard\_transition\_days | Number of days to persist in the standard storage tier before moving to the infrequent access tier | `number` | `30` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| user\_enabled | Set to true to enable the module to create an IAM user | `bool` | `false` | no |
| user\_force\_destroy | Destroy even if it has non-Terraform-managed IAM access keys, login profiles or MFA devices | `bool` | `false` | no |
| user\_path | Path in which to create the user | `string` | `"/"` | no |
| versioning\_enabled | A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket | `bool` | `false` | no |

---

## Outputs

| Name | Description |
|------|-------------|
| access\_key\_id | The access key ID |
| bucket\_arn | Bucket ARN |
| bucket\_domain\_name | FQDN of bucket |
| bucket\_id | Bucket Name (aka ID) |
| secret\_access\_key | The secret access key. This will be written to the state file in plain-text |
| ses\_smtp\_password | The secret access key converted into an SES SMTP password by applying AWS's documented conversion algorithm. |
| user\_arn | The ARN assigned by AWS for this user |
| user\_enabled | Is user creation enabled |
| user\_name | Normalized IAM user name |
| user\_unique\_id | The unique ID assigned by AWS |

## Support

Reach out to me at one of the following places!

- Website at <a href="https://magnetarconsulting.co.uk" target="_blank">`magnetarconsulting.co.uk`</a>
- Twitter at <a href="https://twitter.com/magnetarIT" target="_blank">`@magnetarIT`</a>
- LinkedIn at <a href="https://www.linkedin.com/company/magnetar-it-consulting" target="_blank">`magnetar-it-consulting`</a>

---

## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.
