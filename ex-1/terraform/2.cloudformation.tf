# ------------ Stack -------------
resource "aws_cloudformation_stack" "c3_s3" {
    name = "c3-s3"
    template_body = file("../../starter/c3-s3.yml")
}

resource "aws_cloudformation_stack" "c3_vpc" {
    name = "c3-vpc"
    template_body = file("../../starter/c3-vpc.yml")
    parameters = {
        BucketArnVPCFlowLogs = resource.aws_cloudformation_stack.c3_s3.outputs["BucketArnVPCFlowLogs"]
    } 
}

resource "aws_key_pair" "udacity_keypair" {
    key_name   = "udacity_keypair_macbook"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWINkT7IgBgaPKzDHMTwoMg3TA5ptirK3fp00sn/IH0dXM/cRMz2MhZpcP06Zwd6y1L+cE2RRo9wAuVzIOkt38mFozAJZhPziIGNuaJK9aiF9gRticrF6fHmUCGNVMycnu7LxGDemOmk7xuuaTTfEucBnjrFpAparvm/9OkWfNSfefWnlIZZ4FksxF/H1IilBaGnwqH64LfBQ2C+c9H6TGpG4DQx6c3J0TVllmVdoGXvHLNy+j++DWJtHftmb5NnQcJ7fQhCZd1abZgSLpt+BjmWy5C4eA0DeBZGNRAxQqWUkYEVcrAzs9TKLlHbuai+uV/2cQLpXm0n9k44BrxOX4CElhQvXwps3G+RTKabEynlqppFUEIjvLpKwUx3z1wYO9TNZDZyYbO2pgQDxtaZma9BQsJRemTzEzukQBjTzlY3Y5mt8c3reGsc4ehWkTcCRBVFD4kjzrzJ9YllfjgeCvdF4OuAPloSv0H/poCfoiPZ7t47KQ8d/fQ60MIyGPYH9r787HS7pz4WGLyH+QXvmA1QxlC/KG+ZOEt0DgYUrNOJ4D25lwQTTMTX0AncIIGV8CSfoDHxYFeSLpZGpn6cgbzSJrdmeilSn3ED02w4Sd7P5elaKpFaLIkXu1aF70DMlq/nmwVDtejkdzCxBaZDiCQ1gaVrUOLA7OrHGMoQm6rw== tungplatin@gmail.com"
}

resource "aws_cloudformation_stack" "c3_app" {
    name = "c3-app"
    template_body = file("../../starter/c3-app.yml")
    capabilities = ["CAPABILITY_IAM"]
    parameters = {
        KeyPair = resource.aws_key_pair.udacity_keypair.key_name
        BucketNameRecipesSecret = resource.aws_cloudformation_stack.c3_s3.outputs["BucketNameRecipesSecret"]
        BucketNameRecipesFree = resource.aws_cloudformation_stack.c3_s3.outputs["BucketNameRecipesFree"]
    }
}
