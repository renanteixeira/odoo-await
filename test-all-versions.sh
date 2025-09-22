#!/bin/bash

# Script to test compatibility with all Odoo versions
# Usage: ./test-all-versions.sh

set -e

echo "🧪 Testing odoo-await compatibility with all versions..."

# Arrays with versions and their corresponding ports
versions=(12 13 14 15 16 17 18 19)
ports=(12069 13069 14069 15069 16069 17069 18069 19069)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

passed=0
failed=0

# Loop through all versions
echo "Starting loop with ${#versions[@]} versions: ${versions[*]}"
for i in "${!versions[@]}"; do
    version=${versions[$i]}
    port=${ports[$i]}
    
    echo "Processing version $i: Odoo ${version}.0 on port ${port}"
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${YELLOW}🔍 Testing Odoo ${version}.0 (port ${port})...${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Wait for service to be ready
    echo "⏳ Waiting for Odoo ${version}.0 to be ready..."
    if timeout 180 bash -c "until curl -s http://localhost:${port} > /dev/null; do sleep 2; done"; then
        echo "✅ Odoo ${version}.0 is ready!"
    else
        echo -e "${RED}❌ Odoo ${version}.0 did not respond in 180 seconds${NC}"
        ((failed++))
        continue
    fi
    
    # Run tests specific to this version
    echo "🧪 Running tests..."
    export ODOO_DB="odoo${version}"
    export ODOO_USER="admin"
    export ODOO_PW="admin"
    export ODOO_BASE_URL="http://localhost:${port}"
    
    echo "Environment variables set: ODOO_DB=$ODOO_DB, ODOO_BASE_URL=$ODOO_BASE_URL"
    
    if npm test --silent; then
        echo -e "${GREEN}✅ Odoo ${version}.0 - PASSED all tests!${NC}"
        ((passed++))
    else
        echo -e "${RED}❌ Odoo ${version}.0 - FAILED tests!${NC}"
        ((failed++))
    fi
    
    echo "After test: passed=$passed, failed=$failed"
    
    # Clear environment variables
    unset ODOO_DB ODOO_USER ODOO_PW ODOO_BASE_URL
    
    echo "Completed processing version $version, moving to next..."
done

echo "Loop completed. Final counts: passed=$passed, failed=$failed"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 TEST SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ Versions that passed: ${passed}${NC}"
echo -e "${RED}❌ Versions that failed: ${failed}${NC}"
echo "📝 Total versions tested: $((passed + failed))"

if [ $failed -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 SUCCESS! All Odoo versions are compatible!${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}⚠️  WARNING! Some versions had failures.${NC}"
    exit 1
fi
