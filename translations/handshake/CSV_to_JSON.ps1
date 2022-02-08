
$trainingName = "in-store"

$basepath = $PSScriptRoot + "\"  
$xlsxfile = $basePath + "csvContent.xlsx"
try {   
    if ((Test-Path $xlsxfile) -eq $true) {
        $objExcel = New-Object -ComObject Excel.Application
        $workbook = $objExcel.Workbooks.Open($xlsxfile)
        $workbook.refreshall()
                  
        Start-Sleep -s 5
        $sheet = $WorkBook.sheets.item("material")

        $totalNoOfRecords = ($sheet.UsedRange.Rows).count 
        $col = 1
        while ($null -ne $sheet.Cells.Item(1, $col).value2) {
            if ($col -gt 0) {
                $jsonBase = @{}

                for ($i = 2; $i -le $totalNoOfRecords; $i++) {

                    $key = $sheet.cells.item($i, 1).value2
                    if (!$jsonBase.ContainsKey($key)) {
                        $jsonBase.Add(($sheet.cells.item($i, 1).value2).ToLower(), ($sheet.cells.item($i, $col).value2))
                    }
                }

                $countryCode = ($sheet.Cells.Item(1, $col).text).ToLower()
                if ($countryCode -ne "") {
                    $outFile = $basepath + $countrycode + "_translation_$trainingName.json"
                    $jsonBase | ConvertTo-Json -Depth 10 | Out-File $outFile -Encoding UTF8
                }
            }
            $col += 1
        }
    }
}
catch {
    write-output $_.Exception.Message
}
finally {
    $objExcel.Quit()	
}