# ValidationExecutionPlans — REST API Reference

**API Version:** `2026-02-01-preview`  
**Resource Provider:** `Microsoft.Validate`

> **Back to:** [API Reference Index](./index.md)

---

## Overview

A **ValidationExecutionPlan** resource defines the VM image details (VHD source, OS type, architecture) and the set of validation test suites to run. It is a child of a [CloudValidation](./cloud-validations.md) resource.

**Resource type:** `Microsoft.Validate/cloudValidations/validationExecutionPlans`

The plan configuration is supplied as a JSON-encoded string in the `planConfigurationJson` property. See [ExecutionPlanConfigurationJson](./definitions.md#executionplanconfigurationjson) for the full schema.

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

Creates a new ValidationExecutionPlan resource, or replaces an existing one.

### Request

```http
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the parent CloudValidation resource. |
| `validationExecutionPlanName` | Yes | string | The name of the ValidationExecutionPlan resource. |

#### Request Headers

| Header | Required | Description |
|---|---|---|
| `Authorization` | Yes | Bearer token. `Authorization: Bearer <token>` |
| `Content-Type` | Yes | `application/json` |

#### Request Body

Schema: [ValidationExecutionPlan](./definitions.md#validationexecutionplan)

The `planConfigurationJson` field must be a **JSON-encoded string** containing the full [ExecutionPlanConfigurationJson](./definitions.md#executionplanconfigurationjson) object.

```json
{
  "location": "southcentralus",
  "properties": {
    "description": "Linux image validation plan",
    "planConfigurationJson": "{\"certificationPackageReference\":{\"osType\":\"Linux\",\"architectureType\":\"X64\",\"vmGenerationType\":\"V1\",\"storageProfile\":{\"osDiskImage\":{\"sourceVhdUri\":\"https://<storage>.blob.core.windows.net/<container>/<vhd>.vhd?<sas>\"},\"dataDiskImages\":[]},\"recommendedVMSizes\":[\"Standard_D4s_v3\"],\"additionalProperties\":{}},\"validations\":{\"BasicVMValidation\":{\"testNames\":[\"VM-Boot-Test\"]},\"MalwareValidation\":{},\"VulnerabilityValidation\":{\"thresholdCVSSv3Score\":7.0},\"LinuxQualityValidations\":{\"concurrency\":3,\"testSuite\":[{\"testNames\":[\"smoke_test\",\"verify_dns_name_resolution\",\"verify_no_pre_exist_users\"],\"testArea\":[],\"testCategory\":[],\"testTags\":[],\"testPriority\":[]}]}}}"
  }
}
```

| Field | Required | Type | Description |
|---|---|---|---|
| `location` | Yes | string | Azure region. Must match the parent CloudValidation location. |
| `tags` | No | object | Resource tags. |
| `properties.description` | No | string | Human-readable description. |
| `properties.planConfigurationJson` | Yes* | string | JSON-encoded [ExecutionPlanConfigurationJson](./definitions.md#executionplanconfigurationjson). Required on create. |

> **Note:** `planConfigurationJson` is a **string** in the ARM request body—the JSON object inside it must be serialized (escaped) as a string value. See the [readable configuration example](#plan-configuration-example) below for the unescaped schema.

#### Plan Configuration Example

The following shows the `planConfigurationJson` content as a readable (unescaped) JSON object. When submitting to the API, this must be serialized to a string.

```json
{
  "certificationPackageReference": {
    "osType": "Linux",
    "architectureType": "X64",
    "vmGenerationType": "V1",
    "storageProfile": {
      "osDiskImage": {
        "sourceVhdUri": "https://<storage>.blob.core.windows.net/<container>/<image>.vhd?<sas_token>"
      },
      "dataDiskImages": []
    },
    "recommendedVMSizes": ["Standard_D4s_v3"],
    "additionalProperties": {}
  },
  "validations": {
    "BasicVMValidation": {
      "testNames": ["VM-Boot-Test"]
    },
    "MalwareValidation": {},
    "VulnerabilityValidation": {
      "thresholdCVSSv3Score": 7.0
    },
    "LinuxQualityValidations": {
      "concurrency": 3,
      "testSuite": [
        {
          "testNames": [
            "smoke_test",
            "validate_netvsc_reload",
            "verify_no_pre_exist_users",
            "verify_dns_name_resolution",
            "verify_mdatp_not_preinstalled",
            "verify_deployment_provision_premium_disk",
            "verify_deployment_provision_standard_ssd_disk",
            "verify_deployment_provision_ephemeral_managed_disk",
            "verify_deployment_provision_synthetic_nic",
            "verify_reboot_in_platform",
            "verify_stop_start_in_platform",
            "verify_bash_history_is_empty",
            "verify_client_active_interval",
            "verify_no_swap_on_osdisk",
            "verify_serial_console_is_enabled",
            "verify_openssl_version",
            "verify_azure_64bit_os",
            "verify_waagent_version",
            "verify_python_version",
            "verify_omi_version"
          ],
          "testArea": [],
          "testCategory": [],
          "testTags": [],
          "testPriority": []
        }
      ]
    }
  }
}
```

For a Windows image example:

```json
{
  "certificationPackageReference": {
    "osType": "Windows",
    "architectureType": "X64",
    "vmGenerationType": "V2",
    "storageProfile": {
      "osDiskImage": {
        "sourceVhdUri": "https://<storage>.blob.core.windows.net/<container>/<windows-image>.vhd?<sas_token>"
      },
      "dataDiskImages": []
    },
    "recommendedVMSizes": ["Standard_D4s_v3"]
  },
  "validations": {
    "BasicVMValidation": {
      "testNames": ["VM-Boot-Test"]
    },
    "MalwareValidation": {},
    "VulnerabilityValidation": {}
  }
}
```

### Response

#### 200 OK — Resource updated

#### 201 Created — Resource created (async)

Response headers:

| Header | Description |
|---|---|
| `azure-asyncoperation` | URL to poll for async operation status. |
| `location` | URL to poll for the result. |
| `retry-after` | Suggested polling interval in seconds. |

**Response body:** [ValidationExecutionPlan](./definitions.md#validationexecutionplan)

```json
{
  "id": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}",
  "name": "{validationExecutionPlanName}",
  "type": "Microsoft.Validate/cloudValidations/validationExecutionPlans",
  "location": "southcentralus",
  "properties": {
    "description": "Linux image validation plan",
    "planConfigurationJson": "{...}",
    "provisioningState": "Succeeded",
    "overallState": "Enabled"
  }
}
```

### Example — Azure CLI

```bash
# Prepare the planConfigurationJson as a string
PLAN_CONFIG=$(cat << 'EOF'
{
  "certificationPackageReference": {
    "osType": "Linux",
    "architectureType": "X64",
    "storageProfile": {
      "osDiskImage": {
        "sourceVhdUri": "https://<storage>.blob.core.windows.net/<container>/<vhd>.vhd?<sas>"
      }
    }
  },
  "validations": {
    "BasicVMValidation": { "testNames": ["VM-Boot-Test"] },
    "MalwareValidation": {}
  }
}
EOF
)

az rest \
  --method PUT \
  --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{planName}?api-version=2026-02-01-preview" \
  --body "{
    \"location\": \"southcentralus\",
    \"properties\": {
      \"planConfigurationJson\": $(echo $PLAN_CONFIG | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
    }
  }"
```

---

## Get

Retrieves a ValidationExecutionPlan resource by name.

### Request

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the parent CloudValidation resource. |
| `validationExecutionPlanName` | Yes | string | The name of the ValidationExecutionPlan resource. |

### Response

#### 200 OK

**Response body:** [ValidationExecutionPlan](./definitions.md#validationexecutionplan)

```json
{
  "id": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}",
  "name": "{validationExecutionPlanName}",
  "type": "Microsoft.Validate/cloudValidations/validationExecutionPlans",
  "location": "southcentralus",
  "properties": {
    "description": "Linux image validation plan",
    "planConfigurationJson": "{\"certificationPackageReference\":{...},\"validations\":{...}}",
    "provisioningState": "Succeeded",
    "overallState": "Enabled"
  }
}
```

---

## Update

Partially updates a ValidationExecutionPlan resource (PATCH / JSON Merge Patch).

### Request

```http
PATCH https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the parent CloudValidation resource. |
| `validationExecutionPlanName` | Yes | string | The name of the ValidationExecutionPlan resource. |

#### Request Body

Schema: [ValidationExecutionPlanUpdate](./definitions.md#validationexecutionplanupdate)

```json
{
  "tags": {
    "updated": "true"
  },
  "properties": {
    "description": "Updated description"
  }
}
```

### Response

#### 200 OK

**Response body:** [ValidationExecutionPlan](./definitions.md#validationexecutionplan)

#### 202 Accepted (async update)

---

## Delete

Deletes a ValidationExecutionPlan resource.

> **Note:** An execution plan with active `executionPlanRuns` may still be deleted; however, it is recommended to let any running executions complete first.

### Request

```http
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/{validationExecutionPlanName}?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the parent CloudValidation resource. |
| `validationExecutionPlanName` | Yes | string | The name of the ValidationExecutionPlan resource. |

### Response

#### 202 Accepted

Async delete accepted. Poll the `azure-asyncoperation` / `location` header for completion.

#### 204 No Content

Resource not found or already deleted.

---

## List by Resource Group

Lists all ValidationExecutionPlan resources under a CloudValidation in a resource group.

### Request

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `resourceGroupName` | Yes | string | The name of the resource group. |
| `cloudValidationName` | Yes | string | The name of the parent CloudValidation resource. |

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

**Response body:** [ValidationExecutionPlanListResult](./definitions.md#validationexecutionplanlistresult)

```json
{
  "value": [
    {
      "id": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans/my-plan",
      "name": "my-plan",
      "type": "Microsoft.Validate/cloudValidations/validationExecutionPlans",
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

---

## List by Subscription

Lists all ValidationExecutionPlan resources for a CloudValidation across all resource groups in a subscription.

### Request

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Validate/cloudValidations/{cloudValidationName}/validationExecutionPlans?api-version=2026-02-01-preview
```

#### URI Parameters

| Parameter | Required | Type | Description |
|---|---|---|---|
| `subscriptionId` | Yes | string | The Azure subscription ID. |
| `cloudValidationName` | Yes | string | The name of the CloudValidation resource. |

#### Query Parameters

Same as [List by Resource Group](#list-by-resource-group).

### Response

#### 200 OK

**Response body:** [ValidationExecutionPlanListResult](./definitions.md#validationexecutionplanlistresult)

---

## See Also

- [ValidationExecutionPlan schema definitions](./definitions.md#validationexecutionplan)
- [ExecutionPlanConfigurationJson schema](./definitions.md#executionplanconfigurationjson)
- [ExecutionPlanRuns](./execution-plan-runs.md)
- [CloudValidations](./cloud-validations.md)
- [API Reference Index](./index.md)
