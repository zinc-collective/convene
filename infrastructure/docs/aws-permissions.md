## AWS IAM policy for Packer

[Minimal set permissions necessary for Packer to work](https://www.packer.io/docs/builders/amazon.html#iam-task-or-instance-role)
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DeregisterImage",
                "ec2:DeleteSnapshot",
                "ec2:DescribeInstances",
                "ec2:CreateKeyPair",
                "ec2:DescribeRegions",
                "ec2:CreateImage",
                "ec2:CopyImage",
                "ec2:ModifyImageAttribute",
                "ec2:DescribeSnapshots",
                "ec2:DeleteVolume",
                "ec2:ModifySnapshotAttribute",
                "ec2:CreateSecurityGroup",
                "ec2:DescribeVolumes",
                "ec2:CreateSnapshot",
                "ec2:ModifyInstanceAttribute",
                "ec2:DescribeInstanceStatus",
                "ec2:DetachVolume",
                "ec2:TerminateInstances",
                "ec2:DescribeTags",
                "ec2:CreateTags",
                "ec2:RegisterImage",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:DescribeSecurityGroups",
                "ec2:CreateVolume",
                "ec2:DescribeImages",
                "ec2:GetPasswordData",
                "ec2:DescribeImageAttribute",
                "ec2:DeleteSecurityGroup",
                "ec2:DescribeSubnets",
                "ec2:DeleteKeyPair"
            ],
            "Resource": "*"
        }
    ]
}
```
