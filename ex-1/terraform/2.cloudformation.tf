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
    key_name   = "udacity_keypair"
    public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKq+hWCxYeg9sZ+hFJr7YwIjAKMBF1aBkAH9AEghSRm4 tungplatin@gmail.com"
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
