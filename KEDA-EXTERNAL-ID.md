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

### Using with AWS Scalers

When using AWS scalers (SQS, Kinesis, DynamoDB, etc.), you can now specify an external ID for cross-account access using Pod Identity:

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
    authenticationRef:
      name: keda-trigger-auth-aws-credentials
---
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: keda-trigger-auth-aws-credentials
  namespace: default
spec:
  podIdentity:
    provider: aws  # AWS Pod Identity provider
    roleArn: arn:aws:iam::123456789:role/keda-role  # Role to assume
    awsExternalID: my-external-id  # NEW: External ID support for cross-account access
```

**Note**: The `awsExternalID` parameter is now part of the `podIdentity` configuration in `TriggerAuthentication`, not a scaler parameter. This makes it available to all AWS scalers (SQS, Kinesis, DynamoDB, CloudWatch, etc.) that use the same authentication.

## Changes from Original KEDA

This custom version adds support for AWS External ID parameter in the Pod Identity configuration, enabling secure cross-account access patterns commonly used in enterprise environments. The External ID is now a shared configuration option available to all AWS scalers through the `TriggerAuthentication` resource.

## Source Code

The modified KEDA source code with external ID support can be found at: [Link to your KEDA fork]

## Support

This is a community-maintained fork. For issues specific to the external ID functionality, please create an issue in this repository. 