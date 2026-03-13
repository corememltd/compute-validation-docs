# Microsoft.Validate REST API Reference (2026-02-01-preview)

**Private Preview — Confidential**

> This documentation covers the **Microsoft.Validate** Azure Resource Manager REST API for the Compute Validation for VM Image service. The API version covered is **`2026-02-01-preview`**.
>
> For onboarding, prerequisites, and end-to-end usage guidance, see the [Compute Validation Onboarding Guide](../ComputeValidation_VMImage_Private_Preview_Onboarding.md).

---

## Overview

The **Compute Validation** service exposes ARM REST APIs under the `Microsoft.Validate` resource provider. These APIs let you pre-validate Virtual Machine (VM) images using the same infrastructure that protects Azure Marketplace—directly from your own subscription and CI/CD workflows.

**Base URL:**

```
https://management.azure.com
```

**API Version:**

```
2026-02-01-preview
```

All requests must include the query parameter `?api-version=2026-02-01-preview`.

---

## Authentication

All API calls must be authenticated with a valid Azure AD bearer token scoped to `https://management.azure.com/.default`.

```
Authorization: Bearer <access_token>
```

---

## Resource Hierarchy

```
Microsoft.Validate
└── cloudValidations                       (Tracked Resource)
    └── validationExecutionPlans           (Tracked Resource)
        └── executionPlanRuns              (Proxy Resource)
```

| Resource Type | Description |
|---|---|
| `Microsoft.Validate/cloudValidations` | Top-level resource that scopes validation activity for a subscription/resource group. |
| `Microsoft.Validate/cloudValidations/validationExecutionPlans` | Defines the VM image, OS, architecture, and test suites to execute. |
| `Microsoft.Validate/cloudValidations/validationExecutionPlans/executionPlanRuns` | Triggers execution of a plan and captures the results. |

---

## Operations

### CloudValidations

| Operation | Method | Path |
|---|---|---|
| [Create or Update](./cloud-validations.md#create-or-update) | `PUT` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}` |
| [Get](./cloud-validations.md#get) | `GET` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}` |
| [Update](./cloud-validations.md#update) | `PATCH` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}` |
| [Delete](./cloud-validations.md#delete) | `DELETE` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}` |
| [List by Resource Group](./cloud-validations.md#list-by-resource-group) | `GET` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations` |
| [List by Subscription](./cloud-validations.md#list-by-subscription) | `GET` | `/subscriptions/{subscriptionId}/providers/Microsoft.Validate/cloudValidations` |

### ValidationExecutionPlans

| Operation | Method | Path |
|---|---|---|
| [Create or Update](./validation-execution-plans.md#create-or-update) | `PUT` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}` |
| [Get](./validation-execution-plans.md#get) | `GET` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}` |
| [Update](./validation-execution-plans.md#update) | `PATCH` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}` |
| [Delete](./validation-execution-plans.md#delete) | `DELETE` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}` |
| [List by Resource Group](./validation-execution-plans.md#list-by-resource-group) | `GET` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans` |
| [List by Subscription](./validation-execution-plans.md#list-by-subscription) | `GET` | `/subscriptions/{subscriptionId}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans` |

### ExecutionPlanRuns

| Operation | Method | Path |
|---|---|---|
| [Create or Update](./execution-plan-runs.md#create-or-update) | `PUT` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}/executionPlanRuns/{executionPlanRunName}` |
| [Get](./execution-plan-runs.md#get) | `GET` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}/executionPlanRuns/{executionPlanRunName}` |
| [Delete](./execution-plan-runs.md#delete) | `DELETE` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}/executionPlanRuns/{executionPlanRunName}` |
| [List by Execution Plan](./execution-plan-runs.md#list-by-execution-plan) | `GET` | `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}/executionPlanRuns` |

### Async Operation Status

| Operation | Method | Path |
|---|---|---|
| [Get Operation Status](./operations.md#get-operation-status) | `GET` | `/subscriptions/{subscriptionId}/providers/Microsoft.Validate/locations/{location}/operationStatuses/{operationId}` |
| [List Provider Operations](./operations.md#list-provider-operations) | `GET` | `/providers/Microsoft.Validate/operations` |

---

## Common HTTP Response Codes

| Status Code | Description |
|---|---|
| `200 OK` | The request succeeded. |
| `201 Created` | The resource was created or updated successfully. |
| `202 Accepted` | The request was accepted for asynchronous processing. Poll the `azure-asyncoperation` or `location` header URL for completion. |
| `204 No Content` | The request succeeded; no response body (e.g., DELETE). |
| `400 Bad Request` | Invalid input. Check request body and parameters. |
| `401 Unauthorized` | Missing or invalid authentication token. |
| `403 Forbidden` | The caller does not have permission. |
| `404 Not Found` | The resource was not found. |
| `409 Conflict` | A conflicting resource state prevented the operation. |
| `500 Internal Server Error` | An unexpected server-side error occurred. |

---

## Long-Running Operations (LRO)

Create, update, and delete operations on `cloudValidations`, `validationExecutionPlans`, and `executionPlanRuns` are **asynchronous**. When the service accepts such a request:

1. The initial response returns HTTP `201 Created` or `202 Accepted`.
2. Response headers include `azure-asyncoperation` and/or `location` pointing to an operation status URL.
3. Poll that URL with `GET` until the `status` field reaches a terminal value: `Succeeded`, `Failed`, or `Canceled`.

See [Get Operation Status](./operations.md#get-operation-status) for details on polling.

---

## Data Types Reference

Common schemas shared across operations are documented in the [Definitions Reference](./definitions.md).

---

## Related Resources

- [Onboarding Guide](../ComputeValidation_VMImage_Private_Preview_Onboarding.md)
- [OpenAPI Specification](../api/computevalidation-selfserve.openapi.json)
- [ARM Template](../scripts/computevalidation.subscription.template.json)
- [ARM Template Parameters](../scripts/computevalidation.subscription.parameters.json)
