const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "ap-southeast-1:21c2dc37-759c-4ebd-a1cf-0c1e8a82051e",
                            "Region": "ap-southeast-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "ap-southeast-1_aOvxr43wF",
                        "AppClientId": "5nit92k7doumt47alp5otd1jqi",
                        "Region": "ap-southeast-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "authbillfoldify-dev.auth.ap-southeast-1.amazoncognito.com",
                            "AppClientId": "5nit92k7doumt47alp5otd1jqi",
                            "SignInRedirectURI": "billfoldify://login/",
                            "SignOutRedirectURI": "billfoldify://logout/",
                            "Scopes": [
                                "phone",
                                "email",
                                "openid",
                                "profile",
                                "aws.cognito.signin.user.admin"
                            ]
                        },
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "mfaConfiguration": "OPTIONAL",
                        "mfaTypes": [
                            "SMS",
                            "TOTP"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "signupAttributes": [],
                        "socialProviders": [
                            "GOOGLE",
                            "APPLE"
                        ],
                        "usernameAttributes": [
                            "EMAIL",
                            "PHONE_NUMBER"
                        ],
                        "verificationMechanisms": [
                            "PHONE_NUMBER"
                        ]
                    }
                }
            }
        }
    }
}''';
