# convert-to-lf.ps1
# Recursively convert line endings from CRLF to LF for:
# - *.sh
# - mvnw
# - maven-wrapper.properties

$patterns = @("*.sh", "mvnw", "maven-wrapper.properties")

foreach ($pattern in $patterns) {
    Get-ChildItem -Recurse -File -Filter $pattern | ForEach-Object {
        Write-Host "Converting $($_.FullName)..."

        $content = Get-Content $_.FullName -Raw
        if ($content -match "`r`n") {
            $content -replace "`r`n", "`n" | Set-Content $_.FullName -NoNewline
        }
    }
}

Write-Host "Conversion complete."
