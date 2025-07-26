#!/bin/bash

# Script to test compatibility with all Odoo versions
# Usage: ./test-all-versions.sh

set -e

echo "🧪 Testing odoo-await compatibility with all versions..."

# Arrays with versions and their corresponding ports
versions=(12 13 14 15 16 17 18)
ports=(12069 13069 14069 15069 16069 17069 18069)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

passed=0
failed=0

# Loop through all versions
for i in "${!versions[@]}"; do
    version=${versions[$i]}
    port=${ports[$i]}
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${YELLOW}🔍 Testing Odoo ${version}.0 (port ${port})...${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Wait for service to be ready
    echo "⏳ Waiting for Odoo ${version}.0 to be ready..."
    timeout 60 bash -c "until curl -s http://localhost:${port} > /dev/null; do sleep 2; done" || {
        echo -e "${RED}❌ Odoo ${version}.0 did not respond in 60 seconds${NC}"
        ((failed++))
        continue
    }
    
    # Run tests specific to this version
    echo "🧪 Running tests..."
    if ODOO_DB=odoo${version} ODOO_USER=admin ODOO_PW=admin ODOO_BASE_URL=http://localhost:${port} npm test; then
        echo -e "${GREEN}✅ Odoo ${version}.0 - PASSED all tests!${NC}"
        ((passed++))
    else
        echo -e "${RED}❌ Odoo ${version}.0 - FAILED tests!${NC}"
        ((failed++))
    fi
done

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
