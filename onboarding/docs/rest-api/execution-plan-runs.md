# ExecutionPlanRuns — REST API Reference

**API Version:** `2026-02-01-preview`  
**Resource Provider:** `Microsoft.Validate`

> **Back to:** [API Reference Index](./index.md)

---

## Overview

An **ExecutionPlanRun** resource triggers the execution of a [ValidationExecutionPlan](./validation-execution-plans.md) and captures results. It is a **proxy resource** (child of `validationExecutionPlans`). Each run is immutable once created—re-running validation requires creating a new `executionPlanRuns` resource.

**Resource type:** `Microsoft.Validate/cloudValidations/validationExecutionPlans/executionPlanRuns`

---

## Lifecycle

```
PUT executionPlanRuns/{name}
       │
       ▼
  provisioningState: Accepted → Provisioning
       │
       ▼ (async — poll until terminal)
  provisioningState: Succeeded | Failed | Canceled
  status: Succeeded | Running | Failed | TimedOut | ...
```

> **Note:** Once an ExecutionPlanRun is created, it **cannot be cancelled**. If triggered unintentionally, the run will complete and may incur costs for provisioned Azure resources.

---

## Operations

- [Create or Update](#create-or-update)
- [Get](#get)
- [Delete](#delete)
- [List by Execution Plan](#list-by-execution-plan)

---

## Create or Update

Creates a new ExecutionPlanRun, triggering execution of the parent ValidationExecutionPlan.

### Request

```http
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}/executionPlanRuns/{executionPlanRunName}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the parent CloudValidation resource. |
| `validationExecutionPlanName` | Yes | string | The name of the parent ValidationExecutionPlan resource. |
| `executionPlanRunName` | Yes | string | The name for this execution plan run. Must be unique within the plan. |

#### Request Headers

| Header | Required | Description |
|---|---|---|
| `Authorization` | Yes | Bearer token. `Authorization: Bearer <token>` |
| `Content-Type` | Yes | `application/json` |

#### Request Body

Schema: [ExecutionPlanRun](./definitions.md#executionplanrun)

```json
{
  "properties": {
    "description": "First validation run"
  }
}
```

| Field | Required | Type | Description |
|---|---|---|---|
| `properties.description` | No | string | Human-readable description of this run. |

> **Note:** The `executionPlanRuns` resource is a **proxy resource** and does not have a `location` property.

### Response

#### 200 OK — Run resource updated (idempotent)

#### 201 Created — Run created and execution started (async)

Response headers:

| Header | Description |
|---|---|
| `azure-asyncoperation` | URL to poll for the async operation status. |
| `location` | URL to poll for the result. |
| `retry-after` | Suggested polling interval in seconds. |

**Response body:** [ExecutionPlanRun](./definitions.md#executionplanrun)

```json
{
  "id": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}/executionPlanRuns/{executionPlanRunName}",
  "name": "{executionPlanRunName}",
  "type": "Microsoft.Validate/cloudValidations/validationExecutionPlans/executionPlanRuns",
  "properties": {
    "description": "First validation run",
    "status": "Running",
    "startTimestampInUtc": "2026-02-01T10:00:00Z",
    "endTimestampInUtc": null,
    "reportedTimestampInUtc": null,
    "testRuns": [],
    "provisioningState": "Provisioning"
  }
}
```

### Example — Azure CLI

```bash
az rest \
  --method PUT \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{planName}/executionPlanRuns/{runName}?api-version=2026-02-01-preview" \
  --body '{"properties": {"description": "My first run"}}'
```

---

## Get

Retrieves an ExecutionPlanRun resource by name, including status and test results.

### Request

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}/executionPlanRuns/{executionPlanRunName}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the parent CloudValidation resource. |
| `validationExecutionPlanName` | Yes | string | The name of the parent ValidationExecutionPlan resource. |
| `executionPlanRunName` | Yes | string | The name of the execution plan run. |

### Response

#### 200 OK

**Response body:** [ExecutionPlanRun](./definitions.md#executionplanrun)

##### Example — Run in progress

```json
{
  "id": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{planName}/executionPlanRuns/{runName}",
  "name": "{runName}",
  "type": "Microsoft.Validate/cloudValidations/validationExecutionPlans/executionPlanRuns",
  "properties": {
    "status": "Running",
    "startTimestampInUtc": "2026-02-01T10:00:00Z",
    "endTimestampInUtc": null,
    "reportedTimestampInUtc": null,
    "testRuns": [],
    "provisioningState": "Provisioning"
  }
}
```

##### Example — Run completed (Succeeded)

```json
{
  "id": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{planName}/executionPlanRuns/{runName}",
  "name": "{runName}",
  "type": "Microsoft.Validate/cloudValidations/validationExecutionPlans/executionPlanRuns",
  "properties": {
    "status": "Succeeded",
    "startTimestampInUtc": "2026-02-01T10:00:00Z",
    "endTimestampInUtc": "2026-02-01T10:45:00Z",
    "reportedTimestampInUtc": "2026-02-01T10:45:05Z",
    "testRuns": [
      {
        "id": "testrun-001",
        "name": "MalwareValidation",
        "properties": {
          "status": "Completed",
          "provisioningState": "Succeeded",
          "startTimestampInUtc": "2026-02-01T10:05:00Z",
          "endTimestampInUtc": "2026-02-01T10:20:00Z",
          "reportedTimestampInUtc": "2026-02-01T10:20:05Z",
          "passDetails": [
            {
              "resultCode": "PASS",
              "testName": "MalwareScan",
              "resultDetails": "No malware detected."
            }
          ],
          "failureDetails": []
        }
      },
      {
        "id": "testrun-002",
        "name": "BasicVMValidation",
        "properties": {
          "status": "Completed",
          "provisioningState": "Succeeded",
          "startTimestampInUtc": "2026-02-01T10:10:00Z",
          "endTimestampInUtc": "2026-02-01T10:30:00Z",
          "passDetails": [
            {
              "resultCode": "PASS",
              "testName": "VM-Boot-Test",
              "resultDetails": "VM booted successfully."
            }
          ],
          "failureDetails": []
        }
      }
    ],
    "provisioningState": "Succeeded"
  }
}
```

##### Example — Run with failures

```json
{
  "properties": {
    "status": "Failed",
    "testRuns": [
      {
        "id": "testrun-003",
        "name": "LinuxQualityValidations/verify_dns_name_resolution",
        "properties": {
          "status": "Completed",
          "passDetails": [],
          "failureDetails": [
            {
              "errorCode": "DNS_RESOLUTION_FAILURE",
              "errorMessage": "DNS resolution failed for host 'example.com'.",
              "details": "The VM could not resolve DNS names. Check /etc/resolv.conf.",
              "diagnosticInfo": "Exit code: 1, stderr: ...",
              "recommendedActions": [
                "Ensure the VM image has a valid /etc/resolv.conf.",
                "Verify DNS server configuration.",
                "Ensure network connectivity from the image."
              ]
            }
          ]
        }
      }
    ],
    "provisioningState": "Succeeded"
  }
}
```

### Polling for Completion

Validation runs asynchronously. Poll the `Get` endpoint until `provisioningState` reaches a terminal value:

| `provisioningState` | Meaning |
|---|---|
| `Provisioning` / `Accepted` | Still in progress. Continue polling. |
| `Succeeded` | Run completed. Check `status` and `testRuns` for results. |
| `Failed` | Run failed. Check `testRuns[].properties.failureDetails`. |
| `Canceled` | Run was cancelled. |

Recommended polling interval: **30–60 seconds**.

### Example — Poll using Azure CLI

```bash
# Poll until provisioningState != Provisioning/Accepted
while true; do
  STATE=$(az rest \
    --method GET \
    --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{planName}/executionPlanRuns/{runName}?api-version=2026-02-01-preview" \
    --query "properties.provisioningState" -o tsv)
  echo "State: $STATE"
  if [[ "$STATE" == "Succeeded" || "$STATE" == "Failed" || "$STATE" == "Canceled" ]]; then
    break
  fi
  sleep 30
done
```

---

## Delete

Deletes an ExecutionPlanRun resource.

> **Note:** Deleting a run resource does not stop an in-progress validation. Execution continues until completion.

### Request

```http
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}/executionPlanRuns/{executionPlanRunName}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the parent CloudValidation resource. |
| `validationExecutionPlanName` | Yes | string | The name of the parent ValidationExecutionPlan resource. |
| `executionPlanRunName` | Yes | string | The name of the execution plan run. |

### Response

#### 202 Accepted

Async delete accepted. Poll the `azure-asyncoperation` / `location` header URL for completion.

#### 204 No Content

Resource not found or already deleted.

---

## List by Execution Plan

Lists all ExecutionPlanRun resources for a given ValidationExecutionPlan.

### Request

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}/executionPlanRuns?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the parent CloudValidation resource. |
| `validationExecutionPlanName` | Yes | string | The name of the parent ValidationExecutionPlan resource. |

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

**Response body:** [ExecutionPlanRunListResult](./definitions.md#executionplanrunlistresult)

```json
{
  "value": [
    {
      "id": "...",
      "name": "validation-eprun-01",
      "type": "Microsoft.Validate/cloudValidations/validationExecutionPlans/executionPlanRuns",
      "properties": {
        "status": "Succeeded",
        "provisioningState": "Succeeded",
        "startTimestampInUtc": "2026-02-01T10:00:00Z",
        "endTimestampInUtc": "2026-02-01T10:45:00Z"
      }
    }
  ],
  "nextLink": null
}
```

---

## ExecutionPlanRunStatus Values

| Value | Description |
|---|---|
| `Succeeded` | All validation test runs completed successfully. |
| `Running` | Execution is currently in progress. |
| `Canceled` | The run was canceled. |
| `Failed` | One or more test runs failed. |
| `Waiting` | The run is waiting to start. |
| `Skipped` | The run was skipped. |
| `Paused` | The run is paused. |
| `Suspended` | The run is suspended. |
| `TimedOut` | The run exceeded its time limit. |
| `Aborted` | The run was aborted. |
| `Ignored` | The run was ignored. |
| `Unknown` | The run state is unknown. |

---

## See Also

- [ExecutionPlanRun schema definitions](./definitions.md#executionplanrun)
- [ValidationExecutionPlans](./validation-execution-plans.md)
- [CloudValidations](./cloud-validations.md)
- [API Reference Index](./index.md)
