# KEDA with AWS External ID Support

This repository contains a custom KEDA Helm chart that includes support for AWS External ID in the AWS SQS scaler.

## What's Modified

- **Docker Images**: Updated to use custom images from `tangobango/` registry
  - `tangobango/keda:v2.17.2-external-id`
  - `tangobango/keda-metrics-apiserver:v2.17.2-external-id`
  - `tangobango/keda-admission-webhooks:v2.17.2-external-id`

- **Version**: Chart version `2.17.2-external-id`

## Installation

### Add the Helm Repository

```bash
helm repo add keda-external-id https://YOUR_USERNAME.github.io/charts
helm repo update
```

### Install KEDA with External ID Support

```bash
helm install keda keda-external-id/keda --namespace keda --create-namespace
```

### Using with AWS SQS Scaler

When using the AWS SQS scaler, you can now specify an external ID for cross-account access:

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: aws-sqs-queue-scaledobject
  namespace: default
spec:
  scaleTargetRef:
    name: aws-sqs-queue-consumer
  triggers:
  - type: aws-sqs-queue
    metadata:
      queueURL: https://sqs.us-east-1.amazonaws.com/123456789/my-queue
      queueLength: "5"
      awsRegion: "us-east-1"
      identityOwner: pod # or operator
    authenticationRef:
      name: keda-trigger-auth-aws-credentials
---
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: keda-trigger-auth-aws-credentials
  namespace: default
spec:
  secretTargetRef:
  - parameter: awsAccessKeyID
    name: keda-aws-secrets
    key: AWS_ACCESS_KEY_ID
  - parameter: awsSecretAccessKey
    name: keda-aws-secrets
    key: AWS_SECRET_ACCESS_KEY
  - parameter: awsExternalId  # NEW: External ID support
    name: keda-aws-secrets
    key: AWS_EXTERNAL_ID
```

## Changes from Original KEDA

This custom version adds support for AWS External ID parameter in the AWS SQS scaler, enabling secure cross-account access patterns commonly used in enterprise environments.

## Source Code

The modified KEDA source code with external ID support can be found at: [Link to your KEDA fork]

## Support

This is a community-maintained fork. For issues specific to the external ID functionality, please create an issue in this repository. 