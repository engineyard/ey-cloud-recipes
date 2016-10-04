##EC2 Classic to VPC Classiclinking

This recipe is for use by Engine Yard customers whose accounts run under EC2 Classic but require VPC Peering. Engine Yard Support can create a VPC for peering purposes, after which Engine Yard provisioned EC2 instances can be [Classiclinked] (https://aws.amazon.com/blogs/aws/classiclink-private-communication-between-classic-ec2-instances-vpc-resources/) to this VPC. This recipe automates Classiclinking for all instances in the relevant environment.

###Prerequisites

1. Engine Yard Support must create a VPC under the customer's existing EY AWS account, then initiate and configure peering. Please [open a ticket with Support] (https://support.cloud.engineyard.com) to arrange this.
2. Support must create an IAM user with an inline policy, granting permissions only for `ec2:AttachClassicLinkVpc`.
3. Support must add metadata entries at the Account level for the IAM user's ID and secret key, with values `classiclink_iam_id` and `classiclink_iam_key`.
4. Support must add metadata entries at the Environment level for the VPC and VPC's default security group that the environment's instances should be Classiclinked to, with values `classiclink_vpc_id` and `classiclink_security_group_id`.

###Running

- The recipe then requires no configuration by the customer, it simple needs enabling in the `/cookbooks/main/recipes/default.rb` file.

###Notes

- An instance can only ever be linked to one VPC.
- If you require instances to be unlinked please request this from EY Support. If you require some instances in an environment to be linked and some not then the recipe will need to be updated to handle this.
