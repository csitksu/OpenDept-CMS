# PowerShell helper to render the Mermaid ERD to PNG/SVG using Docker mermaid-cli
# Usage: .\scripts\render_erd.ps1

$pwd = Get-Location
$repoRoot = $pwd.Path
$input = "docs/erd.mmd"
$outputPng = "docs/erd.png"
$outputSvg = "docs/erd.svg"

Write-Host "Rendering Mermaid ERD from $input to $outputPng and $outputSvg using Docker..."

# On Windows, mount current directory into /data inside container
$cmd = "docker run --rm -v \"$repoRoot`:/data\" minlag/mermaid-cli -i $input -o $outputPng"
Invoke-Expression $cmd

$cmd2 = "docker run --rm -v \"$repoRoot`:/data\" minlag/mermaid-cli -i $input -o $outputSvg"
Invoke-Expression $cmd2

Write-Host "Rendered outputs: $outputPng, $outputSvg"
