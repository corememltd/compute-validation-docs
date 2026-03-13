# Operations — REST API Reference

**API Version:** `2026-02-01-preview`  
**Resource Provider:** `Microsoft.Validate`

> **Back to:** [API Reference Index](./index.md)

---

## Overview

This page covers the **operations metadata endpoint** (listing available ARM operations) and the **async operation status endpoint** used for polling long-running operations.

---

## Operations

- [List Provider Operations](#list-provider-operations)
- [Get Operation Status](#get-operation-status)

---

## List Provider Operations

Returns the list of operations available in the `Microsoft.Validate` resource provider. This endpoint is used by the Azure portal, CLI, and other clients to discover supported actions.

### Request

```http
GET https://management.azure.com/providers/Microsoft.Validate/operations?api-version=2026-02-01-preview
```

#### Query Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `$filter` | No | string | OData filter expression. |
| `$top` | No | integer | Max results per page. |
| `$skip` | No | integer | Results to skip. |
| `$maxpagesize` | No | integer | Max items per page. |
| `$orderby` | No | string | Sort expression. |

### Response

#### 200 OK

Returns a paginated list of operation objects.

```json
{
  "value": [
    {
      "name": "Microsoft.Validate/cloudValidations/read",
      "isDataAction": false,
      "display": {
        "provider": "Microsoft.Validate",
        "resource": "cloudValidations",
        "operation": "Get/List CloudValidation",
        "description": "Get or list cloud validations."
      },
      "origin": "user,system",
      "actionType": "Internal"
    },
    {
      "name": "Microsoft.Validate/cloudValidations/write",
      "isDataAction": false,
      "display": {
        "provider": "Microsoft.Validate",
        "resource": "cloudValidations",
        "operation": "Create/Update CloudValidation",
        "description": "Create or update a cloud validation."
      },
      "origin": "user,system",
      "actionType": "Internal"
    },
    {
      "name": "Microsoft.Validate/cloudValidations/delete",
      "isDataAction": false,
      "display": {
        "provider": "Microsoft.Validate",
        "resource": "cloudValidations",
        "operation": "Delete CloudValidation",
        "description": "Delete a cloud validation."
      },
      "origin": "user,system",
      "actionType": "Internal"
    },
    {
      "name": "Microsoft.Validate/cloudValidations/validationExecutionPlans/read",
      "isDataAction": false,
      "display": {
        "provider": "Microsoft.Validate",
        "resource": "validationExecutionPlans",
        "operation": "Get/List ValidationExecutionPlan",
        "description": "Get or list validation execution plans."
      },
      "origin": "user,system",
      "actionType": "Internal"
    },
    {
      "name": "Microsoft.Validate/cloudValidations/validationExecutionPlans/executionPlanRuns/read",
      "isDataAction": false,
      "display": {
        "provider": "Microsoft.Validate",
        "resource": "executionPlanRuns",
        "operation": "Get/List ExecutionPlanRun",
        "description": "Get or list execution plan runs."
      },
      "origin": "user,system",
      "actionType": "Internal"
    }
  ],
  "nextLink": null
}
```

### Example — Azure CLI

```bash
az rest \
  --method GET \
  --url "https://management.azure.com/providers/Microsoft.Validate/operations?api-version=2026-02-01-preview"
```

---

## Get Operation Status

Returns the current status of an asynchronous (long-running) operation. Use this endpoint to poll for the completion of create, update, or delete operations on CloudValidations, ValidationExecutionPlans, and ExecutionPlanRuns.

### When to Use

When a long-running operation returns HTTP `201 Created` or `202 Accepted`, the response includes one or both of these headers:

- `azure-asyncoperation` — URL to poll for operation status (use this endpoint)
- `location` — URL to poll for the result resource

Poll the `azure-asyncoperation` URL at the interval suggested by the `retry-after` response header (typically 15–60 seconds).

### Request

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Validate/locations/{location}/operationStatuses/{operationId}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `location` | Yes | string | The Azure region where the operation was initiated (e.g., `southcentralus`). |
| `operationId` | Yes | string | The unique operation identifier returned in the `azure-asyncoperation` header. |

### Response

#### 200 OK

**Response body:** Operation status object

```json
{
  "id": "/subscriptions/{subscriptionId}/providers/Microsoft.Validate/locations/southcentralus/operationStatuses/{operationId}",
  "name": "{operationId}",
  "status": "InProgress",
  "startTime": "2026-02-01T10:00:00Z",
  "endTime": null,
  "percentComplete": 35.0,
  "properties": {}
}
```

#### Operation Status Values

| `status` | Terminal | Description |
|---|---|---|
| `InProgress` | No | The operation is still running. Continue polling. |
| `Succeeded` | **Yes** | The operation completed successfully. |
| `Failed` | **Yes** | The operation failed. See `error` for details. |
| `Canceled` | **Yes** | The operation was cancelled. |

#### Example — Succeeded

```json
{
  "id": "/subscriptions/{subscriptionId}/providers/Microsoft.Validate/locations/southcentralus/operationStatuses/{operationId}",
  "name": "{operationId}",
  "status": "Succeeded",
  "startTime": "2026-02-01T10:00:00Z",
  "endTime": "2026-02-01T10:02:15Z",
  "percentComplete": 100.0,
  "properties": {}
}
```

#### Example — Failed

```json
{
  "id": "/subscriptions/{subscriptionId}/providers/Microsoft.Validate/locations/southcentralus/operationStatuses/{operationId}",
  "name": "{operationId}",
  "status": "Failed",
  "startTime": "2026-02-01T10:00:00Z",
  "endTime": "2026-02-01T10:01:00Z",
  "error": {
    "code": "ResourceQuotaExceeded",
    "message": "The subscription has exceeded the allowed quota for resource type 'Microsoft.Validate/cloudValidations'.",
    "details": []
  }
}
```

### Polling Pattern

```
1. Issue PUT/DELETE request
      │
      ▼
2. Receive 201/202 response
   Headers:
     azure-asyncoperation: https://management.azure.com/subscriptions/{sub}/providers/
                           Microsoft.Validate/locations/{location}/operationStatuses/{opId}
     retry-after: 30
      │
      ▼
3. GET azure-asyncoperation URL
      │
      ├── status == "InProgress"  ──► wait retry-after seconds, repeat step 3
      │
      ├── status == "Succeeded"   ──► operation complete; GET the resource for final state
      │
      └── status == "Failed"      ──► operation failed; read error.message for details
```

### Example — Azure CLI Polling

```bash
# Capture the async operation URL from a PUT response header
ASYNC_URL=$(az rest \
  --method PUT \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}?api-version=2026-02-01-preview" \
  --body '{"location":"southcentralus","properties":{}}' \
  --skip-authorization-header \
  --verbose 2>&1 | grep -i "azure-asyncoperation" | awk '{print $2}')

# Poll for completion
while true; do
  STATUS=$(az rest --method GET --url "$ASYNC_URL" --query "status" -o tsv)
  echo "Operation status: $STATUS"
  if [[ "$STATUS" == "Succeeded" || "$STATUS" == "Failed" || "$STATUS" == "Canceled" ]]; then
    break
  fi
  sleep 30
done
```

---

## See Also

- [API Reference Index](./index.md)
- [CloudValidations](./cloud-validations.md)
- [ValidationExecutionPlans](./validation-execution-plans.md)
- [ExecutionPlanRuns](./execution-plan-runs.md)
