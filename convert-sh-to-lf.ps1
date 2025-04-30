# Recursively browse all .sh files
Get-ChildItem -Recurse -Filter *.sh | ForEach-Object {
    Write-Host "Converting $($_.FullName)..."
    
    # Read content, replace CRLF with LF, rewrite file
    $content = Get-Content $_.FullName -Raw
    $content -replace "`r`n", "`n" | Set-Content $_.FullName -NoNewline
}
Write-Host "Conversion complete."
