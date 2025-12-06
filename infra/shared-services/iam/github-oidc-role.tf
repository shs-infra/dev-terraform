resource "aws_iam_openid_connect_provider" "github" {
    url = "https://token.actions.githubusercontent.com"

    client_id_list = [
        "sts.amazonaws.com"
    ]

    thumbprint_list = [
        "6938fd4d98bab03faadb97b34396831e3780aea1"
    ]
}

resource "aws_iam_role" "github_oidc_role" {
    name = "GitHubOIDCRole"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    Federated = "arn:aws:iam::444206648029:oidc-provider/token.actions.githubusercontent.com"
                },
                Action = "sts:AssumeRoleWithWebIdentity",
                Condition = {
                    StringLike = {
                        "token.actions.githubusercontent.com:sub" = "repo:shs-infra/dev-terraform:*",
                    }
                    StringEquals = {
                        "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                    }
                }
            }
        ]
    })
}

resource "aws_iam_policy" "github_oidc_assume_policy" {
    name = "GitHubOIDCRole-AssumeRolePolicy"
    description = "Allows GitHub to assume Terraform execution roles in target account"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "sts:AssumeRole",
                ]
                Effect = "Allow"
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "attach_assume_policy" {
    role = aws_iam_role.github_oidc_role.name
    policy_arn = aws_iam_policy.github_oidc_assume_policy.arn
}