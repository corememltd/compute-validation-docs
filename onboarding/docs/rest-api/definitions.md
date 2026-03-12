# Data Type Definitions — REST API Reference

**API Version:** `2026-02-01-preview`  
**Resource Provider:** `Microsoft.Validate`

> **Back to:** [API Reference Index](./index.md)

---

## Overview

This page documents the shared data types (schemas) used across the `Microsoft.Validate` REST API. All types follow standard Azure Resource Manager conventions.

---

## Resource Types

- [CloudValidation](#cloudvalidation)
- [CloudValidationProperties](#cloudvalidationproperties)
- [CloudValidationUpdate](#cloudvalidationupdate)
- [CloudValidationListResult](#cloudvalidationlistresult)
- [ValidationExecutionPlan](#validationexecutionplan)
- [ValidationExecutionPlanProperties](#validationexecutionplanproperties)
- [ValidationExecutionPlanUpdate](#validationexecutionplanupdate)
- [ValidationExecutionPlanListResult](#validationexecutionplanlistresult)
- [ExecutionPlanRun](#executionplanrun)
- [ExecutionPlanRunProperties](#executionplanrunproperties)
- [ExecutionPlanRunListResult](#executionplanrunlistresult)

## Plan Configuration Types

- [ExecutionPlanConfigurationJson](#executionplanconfigurationjson)
- [VMValidationJobPackageReference](#vmvalidationjobpackagereference)
- [ImageStorageProfile](#imagestorageprofile)
- [OSDiskImage](#osdiskimage)
- [DataDiskImage](#datadiskimage)
- [DiskImage](#diskimage)

## Validation Result Types

- [ValidationTestRunDetails](#validationtestrundetails)
- [ValidationTestRunProperties](#validationtestrunproperties)
- [ValidationTestPassDetails](#validationtestpassdetails)
- [ValidationTestFailureDetails](#validationtestfailuredetails)

## Enum Types

- [OSType](#ostype)
- [OSState](#osstate)
- [ArchitectureType](#architecturetype)
- [VMGenerationType](#vmgenerationtype)
- [ProvisioningState](#provisioningstate)
- [CloudValidationOverallState](#cloudvalidationoverallstate)
- [ValidationExecutionPlanProvisioningState](#validationexecutionplanprovisioningstate)
- [ValidationExecutionPlanOverallState](#validationexecutionplanoverallstate)
- [ExecutionPlanRunStatus](#executionplanrunstatus)
- [ValidationTestRunStatus](#validationtestrunstatus)

---

## CloudValidation

Top-level tracked resource that scopes validation activity.

**Extends:** `TrackedResource` (ARM standard)

| Property | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| `id` | string | — | Yes | Full ARM resource ID. |
| `name` | string | — | Yes | Resource name. |
| `type` | string | — | Yes | `Microsoft.Validate/cloudValidations` |
| `location` | string | Yes | No | Azure region (e.g., `southcentralus`). |
| `tags` | object | No | No | Resource tags (key/value pairs). |
| `properties` | [CloudValidationProperties](#cloudvalidationproperties) | No | No | Resource-specific properties. |

---

## CloudValidationProperties

| Property | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| `description` | string | No | No | Human-readable description of the resource. |
| `provisioningState` | [ProvisioningState](#provisioningstate) | — | Yes | Current provisioning state. |
| `overallState` | [CloudValidationOverallState](#cloudvalidationoverallstate) | No | No | Overall state of the resource. |
| `managedOnBehalfOfConfiguration` | object | — | Yes | Managed-on-behalf-of (MOBO) configuration. See [ARM MOBO docs](https://learn.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/overview). |

---

## CloudValidationUpdate

Payload for PATCH operations on CloudValidation.

| Property | Type | Required | Description |
|---|---|---|---|
| `tags` | object | No | Updated resource tags. |
| `properties.description` | string | No | Updated description. |

---

## CloudValidationListResult

Paginated list response for CloudValidation resources.

| Property | Type | Description |
|---|---|---|
| `value` | [CloudValidation](#cloudvalidation)[] | Array of CloudValidation resources. |
| `nextLink` | string | URL for the next page of results, or `null` if no more pages. |

---

## ValidationExecutionPlan

Tracked resource that defines a VM image and test suites to execute.

**Extends:** `TrackedResource` (ARM standard)

| Property | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| `id` | string | — | Yes | Full ARM resource ID. |
| `name` | string | — | Yes | Resource name. |
| `type` | string | — | Yes | `Microsoft.Validate/cloudValidations/validationExecutionPlans` |
| `location` | string | Yes | No | Azure region. |
| `tags` | object | No | No | Resource tags. |
| `properties` | [ValidationExecutionPlanProperties](#validationexecutionplanproperties) | No | No | Resource-specific properties. |

---

## ValidationExecutionPlanProperties

| Property | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| `description` | string | No | No | Human-readable description. |
| `planConfigurationJson` | string | Yes (on create) | No | JSON-encoded string containing the full [ExecutionPlanConfigurationJson](#executionplanconfigurationjson) object. In GET responses, the full JSON configuration is always returned. |
| `provisioningState` | [ValidationExecutionPlanProvisioningState](#validationexecutionplanprovisioningstate) | — | Yes | Current provisioning state. |
| `overallState` | [ValidationExecutionPlanOverallState](#validationexecutionplanoverallstate) | No | No | Overall state. |

> **Important:** The `planConfigurationJson` value **must be a serialized JSON string** in the request body, not a nested JSON object. Use `JSON.stringify()` or equivalent before submitting.

---

## ValidationExecutionPlanUpdate

Payload for PATCH operations on ValidationExecutionPlan.

| Property | Type | Required | Description |
|---|---|---|---|
| `tags` | object | No | Updated resource tags. |
| `properties.description` | string | No | Updated description. |

---

## ValidationExecutionPlanListResult

Paginated list response for ValidationExecutionPlan resources.

| Property | Type | Description |
|---|---|---|
| `value` | [ValidationExecutionPlan](#validationexecutionplan)[] | Array of ValidationExecutionPlan resources. |
| `nextLink` | string | URL for the next page, or `null`. |

---

## ExecutionPlanRun

Proxy resource that represents a single execution of a ValidationExecutionPlan. Results are captured here.

**Extends:** `ProxyResource` (ARM standard — no `location` property)

| Property | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| `id` | string | — | Yes | Full ARM resource ID. |
| `name` | string | — | Yes | Resource name. |
| `type` | string | — | Yes | `Microsoft.Validate/cloudValidations/validationExecutionPlans/executionPlanRuns` |
| `properties` | [ExecutionPlanRunProperties](#executionplanrunproperties) | No | No | Resource-specific properties. |

---

## ExecutionPlanRunProperties

| Property | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| `description` | string | No | No | Human-readable description of the run. |
| `status` | [ExecutionPlanRunStatus](#executionplanrunstatus) | — | Yes | Current overall status of the execution run. |
| `startTimestampInUtc` | string (date-time) | — | Yes | UTC timestamp when the run started. |
| `endTimestampInUtc` | string (date-time) | — | Yes | UTC timestamp when the run ended. `null` if still running. |
| `reportedTimestampInUtc` | string (date-time) | — | Yes | UTC timestamp when the results were reported. |
| `testRuns` | [ValidationTestRunDetails](#validationtestrundetails)[] | — | Yes | Array of individual test run results (max 100). |
| `provisioningState` | [ProvisioningState](#provisioningstate) | — | Yes | ARM provisioning state. |

---

## ExecutionPlanRunListResult

Paginated list response for ExecutionPlanRun resources.

| Property | Type | Description |
|---|---|---|
| `value` | [ExecutionPlanRun](#executionplanrun)[] | Array of ExecutionPlanRun resources. |
| `nextLink` | string | URL for the next page, or `null`. |

---

## ExecutionPlanConfigurationJson

Schema for the JSON object embedded in `ValidationExecutionPlanProperties.planConfigurationJson`.

| Property | Type | Required | Description |
|---|---|---|---|
| `certificationPackageReference` | [VMValidationJobPackageReference](#vmvalidationjobpackagereference) | Yes | VM image package reference for validation. |
| `validations` | object | Yes | Dictionary of test suite names to suite-specific configuration objects. Keys are suite names (e.g., `BasicVMValidation`, `MalwareValidation`). |

### Supported Validation Suites

| Suite Name | Description | Config Properties |
|---|---|---|
| `BasicVMValidation` | VM boot and functional tests. | `testNames` (string[]): List of test names to run, e.g., `["VM-Boot-Test"]`. |
| `MalwareValidation` | Malware scanning of the VM image. | No configuration required. Pass `{}`. |
| `VulnerabilityValidation` | Vulnerability scanning via Microsoft Defender. | `thresholdCVSSv3Score` (number, optional): CVSSv3 score threshold above which certification fails. |
| `LinuxQualityValidations` | Linux quality tests (LISA). | `concurrency` (integer): Number of parallel test executions. `testSuite` (array): Array of test suite configurations. |

### LinuxQualityValidations testSuite Entry

| Property | Type | Description |
|---|---|---|
| `testNames` | string[] | List of LISA test names to run. |
| `testArea` | string[] | Filter by test area. Pass `[]` for no filter. |
| `testCategory` | string[] | Filter by test category. Pass `[]` for no filter. |
| `testTags` | string[] | Filter by test tags. Pass `[]` for no filter. |
| `testPriority` | string[] | Filter by test priority. Pass `[]` for no filter. |

### Full Example

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

---

## VMValidationJobPackageReference

Describes the VM image to be validated.

| Property | Type | Required | Description |
|---|---|---|---|
| `osType` | [OSType](#ostype) | Yes | OS type of the VM image. |
| `osState` | [OSState](#osstate) | No | OS state: `Generalized` or `Specialized`. |
| `architectureType` | [ArchitectureType](#architecturetype) | No | CPU architecture. |
| `storageProfile` | [ImageStorageProfile](#imagestorageprofile) | Yes | Storage profile containing the VHD reference. |
| `recommendedVMSizes` | string[] | No | Publisher-recommended VM sizes for validation (e.g., `["Standard_D4s_v3"]`). |
| `vmGenerationType` | [VMGenerationType](#vmgenerationtype) | No | VM generation: `V1` or `V2`. |
| `additionalProperties` | object | No | Key/value bag for additional provider-specific inputs. |

---

## ImageStorageProfile

| Property | Type | Required | Description |
|---|---|---|---|
| `osDiskImage` | [OSDiskImage](#osdiskimage) | Yes | Reference to the OS disk VHD. |
| `dataDiskImages` | [DataDiskImage](#datadiskimage)[] | No | Optional array of data disk VHD references. |

---

## OSDiskImage

Extends [DiskImage](#diskimage).

| Property | Type | Required | Description |
|---|---|---|---|
| `sourceVhdUri` | string (uri) | Yes | SAS URI (or accessible blob URI) of the source VHD. Minimum 1-day expiry recommended. Requires **read** and **list** permissions. |

---

## DataDiskImage

Extends [DiskImage](#diskimage).

| Property | Type | Required | Description |
|---|---|---|---|
| `sourceVhdUri` | string (uri) | Yes | SAS URI of the source VHD. |
| `lun` | integer | Yes | Logical unit number (LUN) for the data disk. Minimum: `0`. |

---

## DiskImage

Base type for disk image references.

| Property | Type | Required | Description |
|---|---|---|---|
| `sourceVhdUri` | string (uri) | Yes | Blob URI (typically SAS) of the source VHD. |

---

## ValidationTestRunDetails

Represents a single test run instance within an ExecutionPlanRun.

| Property | Type | Read-Only | Description |
|---|---|---|---|
| `id` | string | Yes | Unique identifier for the test run. |
| `name` | string | No | Name of the test run (e.g., suite and test name). |
| `properties` | [ValidationTestRunProperties](#validationtestrunproperties) | No | Test run properties and results. |

---

## ValidationTestRunProperties

| Property | Type | Read-Only | Description |
|---|---|---|---|
| `status` | [ValidationTestRunStatus](#validationtestrunstatus) | Yes | Overall status of this test run. |
| `provisioningState` | [ProvisioningState](#provisioningstate) | Yes | ARM provisioning state. |
| `startTimestampInUtc` | string (date-time) | Yes | UTC timestamp when this test run started. |
| `endTimestampInUtc` | string (date-time) | Yes | UTC timestamp when this test run ended. |
| `reportedTimestampInUtc` | string (date-time) | Yes | UTC timestamp when results were reported. |
| `inputsJson` | string | No | JSON-encoded inputs used for this test run. |
| `passDetails` | [ValidationTestPassDetails](#validationtestpassdetails)[] | Yes | Detailed pass results (max 100). |
| `failureDetails` | [ValidationTestFailureDetails](#validationtestfailuredetails)[] | Yes | Detailed failure results (max 100). |

---

## ValidationTestPassDetails

| Property | Type | Read-Only | Description |
|---|---|---|---|
| `resultCode` | string | Yes | Code categorizing the pass type. |
| `testName` | string | Yes | Name of the test that passed. |
| `resultDetails` | string | Yes | Detailed description of the pass result. |

---

## ValidationTestFailureDetails

| Property | Type | Read-Only | Description |
|---|---|---|---|
| `errorCode` | string | Yes | Code categorizing the type of failure. |
| `errorMessage` | string | Yes | Human-readable error message describing the failure. |
| `details` | string | Yes | Additional detailed information about the failure. |
| `diagnosticInfo` | string | Yes | Diagnostic information for troubleshooting (e.g., exit codes, stderr). |
| `recommendedActions` | string[] | Yes | Suggested remediation steps. |

---

## Enum Types

### OSType

OS type of the VM image.

| Value | Description |
|---|---|
| `Windows` | Windows OS. |
| `Linux` | Linux OS. |

---

### OSState

State of the OS in the VM image.

| Value | Description |
|---|---|
| `Generalized` | The image has been generalized (sysprepped for Windows, deprovisioned for Linux). |
| `Specialized` | The image is specialized (not generalized). |

---

### ArchitectureType

CPU architecture of the VM image.

| Value | Description |
|---|---|
| `X64` | 64-bit x86 (AMD64/Intel 64). |
| `Arm64` | 64-bit ARM architecture. |

---

### VMGenerationType

VM generation.

| Value | Description |
|---|---|
| `V1` | Generation 1 VM (BIOS-based). |
| `V2` | Generation 2 VM (UEFI-based). |

---

### ProvisioningState

ARM resource provisioning state (used by CloudValidation and ExecutionPlanRun).

| Value | Terminal | Description |
|---|---|---|
| `Succeeded` | Yes | Resource has been created/updated successfully. |
| `Failed` | Yes | Resource creation/update failed. |
| `Canceled` | Yes | Resource creation/update was canceled. |
| `Provisioning` | No | The resource is being provisioned. |
| `Updating` | No | The resource is being updated. |
| `Disabling` | No | The resource is being disabled. |
| `Deleting` | No | The resource is being deleted. |
| `Accepted` | No | The create/update request has been accepted. |

---

### CloudValidationOverallState

| Value | Description |
|---|---|
| `Enabled` | The resource is in the enabled state. |

---

### ValidationExecutionPlanProvisioningState

Provisioning state specific to ValidationExecutionPlan.

| Value | Terminal | Description |
|---|---|---|
| `Succeeded` | Yes | Resource created/updated successfully. |
| `Failed` | Yes | Resource creation/update failed. |
| `Canceled` | Yes | Resource creation/update was canceled. |
| `Creating` | No | The resource is being provisioned. |
| `Updating` | No | The resource is being updated. |
| `Disabling` | No | The resource is being disabled. |
| `Deleting` | No | The resource is being deleted. |

---

### ValidationExecutionPlanOverallState

| Value | Description |
|---|---|
| `Enabled` | The resource is in the enabled state. |

---

### ExecutionPlanRunStatus

Overall status of an ExecutionPlanRun.

| Value | Terminal | Description |
|---|---|---|
| `Succeeded` | Yes | All validation tests completed successfully. |
| `Failed` | Yes | One or more validation tests failed. |
| `Canceled` | Yes | The run was canceled. |
| `TimedOut` | Yes | The run exceeded its time limit. |
| `Aborted` | Yes | The run was aborted. |
| `Running` | No | Execution is in progress. |
| `Waiting` | No | The run is waiting to start. |
| `Paused` | No | The run is paused. |
| `Suspended` | No | The run is suspended. |
| `Skipped` | Yes | The run was skipped. |
| `Ignored` | Yes | The run was ignored. |
| `Unknown` | — | The run state is unknown. |

---

### ValidationTestRunStatus

Status of an individual test run within an ExecutionPlanRun.

| Value | Terminal | Description |
|---|---|---|
| `Completed` | Yes | The test run completed. Check `passDetails` / `failureDetails` for outcome. |
| `Stopped` | Yes | The test run was stopped. |
| `Error` | Yes | The test run encountered an error. |
| `NotRunning` | No | The test run has not started. |
| `Scheduled` | No | The test run is scheduled to run. |
| `Ready` | No | The test run is ready to execute. |
| `Running` | No | The test run is currently executing. |

---

## See Also

- [API Reference Index](./index.md)
- [CloudValidations](./cloud-validations.md)
- [ValidationExecutionPlans](./validation-execution-plans.md)
- [ExecutionPlanRuns](./execution-plan-runs.md)
- [OpenAPI Specification](../api/computevalidation-selfserve.openapi.json)
