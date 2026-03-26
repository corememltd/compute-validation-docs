param location string

param cloudValidationName string
param executionPlanName string
param executionPlanRunName string

param osType string
param osState string
param architectureType string
param vhdSasUri string
param vmGenerationType string

#disable-next-line BCP081
resource cloudValidation 'Microsoft.Validate/cloudValidations@2026-02-01-preview' existing = {
  name: cloudValidationName

  #disable-next-line BCP081
  resource executionPlan 'validationExecutionPlans' = {
    name: executionPlanName
    location: location
    properties: {
      planConfigurationJson: string({
        certificationPackageReference: {
          osType: osType
          osState: osState
          architectureType: architectureType
          storageProfile: {
            osDiskImage: {
              sourceVhdUri: vhdSasUri
            }
            dataDiskImages: []
          }
          vmGenerationType: vmGenerationType
          additionalProperties: {}
        }
        validations: {
          BasicVMValidation: {
            testNames: [
              'VM-Boot-Test'
            ]
          }
          MalwareValidation: {}
          VulnerabilityValidation: {}
          LinuxQualityValidations: {
            concurrency: 3
            testSuite: [
              {
                testNames: [
                  'smoke_test'
//                  'validate_netvsc_reload'
//                  'verify_no_pre_exist_users'
//                  'verify_dns_name_resolution'
//                  'verify_mdatp_not_preinstalled'
//                  'verify_deployment_provision_premium_disk'
//                  'verify_deployment_provision_standard_ssd_disk'
//                  'verify_deployment_provision_ephemeral_managed_disk'
//                  'verify_deployment_provision_synthetic_nic'
//                  'verify_reboot_in_platform'
//                  'verify_stop_start_in_platform'
//                  'verify_bash_history_is_empty'
//                  'verify_client_active_interval'
//                  'verify_no_swap_on_osdisk'
//                  'verify_serial_console_is_enabled'
//                  'verify_openssl_version'
//                  'verify_azure_64bit_os'
//                  'verify_waagent_version'
//                  'verify_python_version'
//                  'verify_omi_version'
                ]
                testArea: []
                testCategory: []
                testTags: []
                testPriority: []
              }
            ]
          }
        }
      })
    }

    #disable-next-line BCP081
    resource executionPlanRun 'executionPlanRuns' = {
      name: executionPlanRunName
    }
  }
}

output id string = cloudValidation.id
