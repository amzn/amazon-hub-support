
$training = "in-store"

try {
    $filesTranslations = Get-ChildItem -Path $PSScriptRoot -Recurse -ErrorAction SilentlyContinue -Filter *.json | Where-Object { $_.Extension -eq '.json' }

    foreach ($file in $filesTranslations) {
        if ($file.Name -match "translation" -and !($file.Name -match "tags")) {
            $countryCode = $file.Name.Substring(0, 2)  
 
            if ((Test-Path ".\$training\$countryCode\index.md") -eq $true) {
                Remove-Item ".\$training\$countryCode\index.md"
            }
    
            $translationRawContent = Get-Content $file.FullName -Raw
            $translationJSONContent = $translationRawContent | ConvertFrom-Json 
            $trainingTemplate = Get-Content ".\$training\template\index.md"
            
            Write-output "Starting translation for $countryCode of training $training"
            foreach ($property in $translationJSONContent.PSObject.Properties) {
                $key = $property.Name
                $value = $property.Value
                $replace = $key
                if ($key.Contains("olist")) {
                    $replacelink = $key+"-link"
                    $valuelink = "#"+$value.Replace(" ","-").ToLower()  
                    $trainingTemplate = $trainingTemplate.Replace($replacelink, $valuelink)
                }
                $trainingTemplate = $trainingTemplate.Replace($replace, $value)
            }
            $trainingTemplate | Set-Content -Encoding UTF8 -Path ".\$training\$countryCode\index.md"
            Write-output "Translation completed for country $countryCode of training $training"
        }
    }
}
catch {
    $message = $_.Exception.Message

    Write-output "Something was wrong when executing the translation for $countryCode of training $training."
    Write-output "Error message: $message"
}
