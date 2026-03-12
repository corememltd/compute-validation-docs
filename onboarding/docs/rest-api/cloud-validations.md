# CloudValidations — REST API Reference

**API Version:** `2026-02-01-preview`  
**Resource Provider:** `Microsoft.Validate`

> **Back to:** [API Reference Index](./index.md)

---

## Overview

A **CloudValidation** resource is the top-level container that scopes all validation activity within an Azure resource group. It is a Tracked Resource (standard ARM type) and must be created before any `validationExecutionPlans` or `executionPlanRuns` can be provisioned beneath it.

**Resource type:** `Microsoft.Validate/cloudValidations`

---

## Operations

- [Create or Update](#create-or-update)
- [Get](#get)
- [Update](#update)
- [Delete](#delete)
- [List by Resource Group](#list-by-resource-group)
- [List by Subscription](#list-by-subscription)

---

## Create or Update

Creates a new CloudValidation resource, or replaces an existing one (full update via PUT).

### Request

```http
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the CloudValidation resource. |

#### Request Headers

| Header | Required | Description |
|---|---|---|
| `Authorization` | Yes | Bearer token. `Authorization: Bearer <token>` |
| `Content-Type` | Yes | `application/json` |

#### Request Body

Schema: [CloudValidation](./definitions.md#cloudvalidation)

```json
{
  "location": "southcentralus",
  "tags": {
    "environment": "private-preview"
  },
  "properties": {
    "description": "Cloud validation for my VM image"
  }
}
```

| Field | Required | Type | Description |
|---|---|---|---|
| `location` | Yes | string | Azure region where the resource is deployed (e.g., `southcentralus`). |
| `tags` | No | object | Resource tags (key/value pairs). |
| `properties.description` | No | string | Human-readable description of the resource. |

### Response

#### 200 OK — Resource updated

#### 201 Created — Resource created (async)

Response headers include:

| Header | Description |
|---|---|
| `azure-asyncoperation` | URL to poll for async operation status. |
| `location` | URL to poll for the result. |
| `retry-after` | Suggested polling interval in seconds. |

**Response body:** [CloudValidation](./definitions.md#cloudvalidation)

```json
{
  "id": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}",
  "name": "{cloudValidationName}",
  "type": "Microsoft.Validate/cloudValidations",
  "location": "southcentralus",
  "tags": {
    "environment": "private-preview"
  },
  "properties": {
    "description": "Cloud validation for my VM image",
    "provisioningState": "Succeeded",
    "overallState": "Enabled"
  }
}
```

### Example — Azure CLI

```bash
az rest \
  --method PUT \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}?api-version=2026-02-01-preview" \
  --body '{
    "location": "southcentralus",
    "properties": {
      "description": "My cloud validation"
    }
  }'
```

---

## Get

Retrieves a CloudValidation resource by name.

### Request

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the CloudValidation resource. |

### Response

#### 200 OK

**Response body:** [CloudValidation](./definitions.md#cloudvalidation)

```json
{
  "id": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}",
  "name": "{cloudValidationName}",
  "type": "Microsoft.Validate/cloudValidations",
  "location": "southcentralus",
  "properties": {
    "description": "Cloud validation for my VM image",
    "provisioningState": "Succeeded",
    "overallState": "Enabled",
    "managedOnBehalfOfConfiguration": {
      "managedByTenantId": "...",
      "managedByResourceId": "..."
    }
  }
}
```

### Example — Azure CLI

```bash
az rest \
  --method GET \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}?api-version=2026-02-01-preview"
```

---

## Update

Performs a partial update of a CloudValidation resource using JSON Merge Patch semantics.

### Request

```http
PATCH https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the CloudValidation resource. |

#### Request Headers

| Header | Required | Description |
|---|---|---|
| `Authorization` | Yes | Bearer token. |
| `Content-Type` | Yes | `application/merge-patch+json` or `application/json` |

#### Request Body

Schema: [CloudValidationUpdate](./definitions.md#cloudvalidationupdate)

```json
{
  "tags": {
    "environment": "private-preview",
    "team": "image-validation"
  },
  "properties": {
    "description": "Updated description"
  }
}
```

| Field | Required | Type | Description |
|---|---|---|---|
| `tags` | No | object | Updated resource tags. Replaces all existing tags if provided. |
| `properties.description` | No | string | Updated description. |

### Response

#### 200 OK

**Response body:** [CloudValidation](./definitions.md#cloudvalidation)

#### 202 Accepted (async update)

Response headers include `azure-asyncoperation` and/or `location` for polling.

---

## Delete

Deletes a CloudValidation resource. This is an asynchronous operation.

> **Warning:** Deleting a CloudValidation also removes all child `validationExecutionPlans` and `executionPlanRuns`.

### Request

```http
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the CloudValidation resource. |

### Response

#### 202 Accepted

The delete operation has been accepted. Poll the URL in the `azure-asyncoperation` or `location` response header for completion.

#### 204 No Content

The resource was not found or has already been deleted.

### Example — Azure CLI

```bash
az rest \
  --method DELETE \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}?api-version=2026-02-01-preview"
```

---

## List by Resource Group

Lists all CloudValidation resources within a specified resource group.

### Request

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |

#### Query Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `$filter` | No | string | OData filter expression to filter results. |
| `$top` | No | integer | Maximum number of results to return per page. |
| `$skip` | No | integer | Number of results to skip (for pagination). |
| `$maxpagesize` | No | integer | Maximum number of result items per page. |
| `$orderby` | No | string (array) | Sort expression for the returned results. |

### Response

#### 200 OK

**Response body:** [CloudValidationListResult](./definitions.md#cloudvalidationlistresult)

```json
{
  "value": [
    {
      "id": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/validation-cv",
      "name": "validation-cv",
      "type": "Microsoft.Validate/cloudValidations",
      "location": "southcentralus",
      "properties": {
        "provisioningState": "Succeeded",
        "overallState": "Enabled"
      }
    }
  ],
  "nextLink": null
}
```

Results are paginated. If `nextLink` is present, issue a `GET` request to that URL to retrieve the next page.

---

## List by Subscription

Lists all CloudValidation resources across all resource groups in a subscription.

### Request

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Validate/cloudValidations?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |

#### Query Parameters

Same pagination and filter parameters as [List by Resource Group](#list-by-resource-group).

### Response

#### 200 OK

**Response body:** [CloudValidationListResult](./definitions.md#cloudvalidationlistresult)

---

## See Also

- [CloudValidation schema definitions](./definitions.md#cloudvalidation)
- [ValidationExecutionPlans](./validation-execution-plans.md)
- [API Reference Index](./index.md)
