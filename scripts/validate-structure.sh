#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "README.md"
  "sfdx-project.json"
  "force-app/main/default/classes/ApexRail.cls"
  "force-app/main/default/classes/ApexRailHandler.cls"
  "force-app/main/default/classes/ApexRailPipeline.cls"
  "force-app/main/default/classes/ApexRailGuard.cls"
  "docs/architecture.md"
)

for required_file in "${required_files[@]}"; do
  if [[ ! -f "$required_file" ]]; then
    echo "Missing required file: $required_file" >&2
    exit 1
  fi
done

while IFS= read -r apex_file; do
  metadata_file="${apex_file}-meta.xml"
  if [[ ! -f "$metadata_file" ]]; then
    echo "Missing metadata companion: $metadata_file" >&2
    exit 1
  fi
done < <(find force-app -name '*.cls' -type f)

echo "ApexRail repository structure is valid."
