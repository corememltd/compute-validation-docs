param location string

param cloudValidationName string

#disable-next-line BCP081
resource cloudValidation 'Microsoft.Validate/cloudValidations@2026-02-01-preview' = {
  name: cloudValidationName
  location: location
}

output id string = cloudValidation.id
