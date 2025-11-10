# Export and classify all references to 'computer vision' across the docset
param(
    [string]$BasePath = 'c:\github\architecture-center-pr\docs',
    [string]$OutputCsv = 'c:\github\architecture-center-pr\docs\computer_vision_references.csv'
)

$pattern = 'computer vision'

function Get-ReferenceType {
    param(
        [string]$Line,
        [string]$FilePath
    )
    $ext = [System.IO.Path]::GetExtension($FilePath).ToLowerInvariant()

    if ($ext -eq '.yml') { return 'metadata' }
    if ($ext -eq '.svg') { return 'diagram-label' }
    if ($ext -eq '.atom') { return 'feed-summary' }

    $trim = $Line.Trim()
    if ($trim -match '^#{1,6}\s+') { return 'heading' }
    if ($trim -match 'alt-text\s*=|alt-text:') { return 'alt-text' }
    if ($trim -match 'Computer Vision API' -or $trim -match '/computer-vision/overview') { return 'service-reference' }
    if ($trim -match '\[.*?\]\(.*computer-vision.*\)' -or $trim -match '\[.*?Computer Vision.*?\]') { return 'link' }
    if ($trim -match 'Custom Vision' -and $trim -match 'computer vision') { return 'custom-vision-comparison' }
    if ($trim -match 'taxonomy-based categories' -and $trim -match 'Computer Vision API') { return 'taxonomy-explanation' }
    if ($trim -match 'OCR' -and $trim -match 'computer vision') { return 'ocr-reference' }
    return 'inline'
}

# Collect matches case-insensitively
$files = Get-ChildItem -Path $BasePath -Recurse -File | Where-Object { $_.Extension -in '.md','.yml','.svg','.atom' }
$results = @()

foreach ($file in $files) {
    try {
        $lines = Get-Content -Path $file.FullName -ErrorAction Stop
        for ($i=0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -imatch $pattern) {
                $type = Get-ReferenceType -Line $lines[$i] -FilePath $file.FullName

                # Build context (previous & next line if exists)
                $prev = if ($i -gt 0) { $lines[$i-1].Trim() } else { '' }
                $next = if ($i -lt $lines.Count-1) { $lines[$i+1].Trim() } else { '' }

                $results += [PSCustomObject]@{
                    File = ($file.FullName -replace [regex]::Escape($BasePath + '\'), '')
                    Line = ($i+1)
                    Type = $type
                    Text = $lines[$i].Trim()
                    Prev = $prev
                    Next = $next
                }
            }
        }
    } catch {
        Write-Warning "Failed to read $($file.FullName): $_"
    }
}

# Dedupe exact same file+line occurrences (just in case)
$results = $results | Sort-Object File, Line | Select-Object File, Line, Type, Text, Prev, Next -Unique

# Export CSV
$results | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8

Write-Host "Export complete: $OutputCsv" -ForegroundColor Green
Write-Host "Total references: $($results.Count)" -ForegroundColor Cyan

# Show sample
$results | Select-Object -First 10 | Format-Table -AutoSize
