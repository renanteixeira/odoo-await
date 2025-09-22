#!/bin/bash

# Management script for multi-version Odoo environment
# Usage: ./manage-odoo.sh [command]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_help() {
    echo -e "${BLUE}🐳 Multi-Version Odoo Manager${NC}"
    echo ""
    echo "Available commands:"
    echo "  init      - Initialize all Odoo services (first time)"
    echo "  start     - Start all services"
    echo "  stop      - Stop all services"
    echo "  restart   - Restart all services"
    echo "  status    - Show services status"
    echo "  test      - Run tests on all versions"
    echo "  logs      - Show logs from all services"
    echo "  clean     - Clean all containers and volumes"
    echo "  urls      - Show access URLs"
    echo ""
    echo "Examples:"
    echo "  ./manage-odoo.sh init     # First initialization"
    echo "  ./manage-odoo.sh test     # Test all versions"
    echo "  ./manage-odoo.sh status   # View services status"
}

show_urls() {
    echo -e "${BLUE}🌐 Access URLs:${NC}"
    echo ""
    echo "📋 Web Interfaces:"
    echo "   Odoo 12.0: http://localhost:12069"
    echo "   Odoo 13.0: http://localhost:13069"
    echo "   Odoo 14.0: http://localhost:14069"
    echo "   Odoo 15.0: http://localhost:15069"
    echo "   Odoo 16.0: http://localhost:16069"
    echo "   Odoo 17.0: http://localhost:17069"
    echo "   Odoo 18.0: http://localhost:18069"
    echo "   Odoo 19.0: http://localhost:19069"
    echo ""
    echo "🔐 Credentials: admin/admin"
    echo "💾 PostgreSQL: localhost:5432 (postgres/postgres)"
    echo "📄 wkhtmltopdf: http://localhost:8080"
}

case "${1:-help}" in
    init)
        echo -e "${YELLOW}🚀 Initializing multi-version Odoo environment...${NC}"
        ./init-all-odoo.sh
        echo ""
        show_urls
        ;;
    start)
        echo -e "${GREEN}▶️  Starting all services...${NC}"
        docker compose up -d
        echo -e "${GREEN}✅ Services started!${NC}"
        ;;
    stop)
        echo -e "${YELLOW}⏹️  Stopping all services...${NC}"
        docker compose down
        echo -e "${YELLOW}✅ Services stopped!${NC}"
        ;;
    restart)
        echo -e "${YELLOW}🔄 Restarting all services...${NC}"
        docker compose restart
        echo -e "${GREEN}✅ Services restarted!${NC}"
        ;;
    status)
        echo -e "${BLUE}📊 Services status:${NC}"
        docker compose ps
        ;;
    test)
        echo -e "${YELLOW}🧪 Running tests on all versions...${NC}"
        ./test-all-versions.sh
        ;;
    logs)
        echo -e "${BLUE}📝 Services logs:${NC}"
        docker compose logs --tail=50
        ;;
    clean)
        echo -e "${RED}🧹 Cleaning project containers and volumes...${NC}"
        read -p "Are you sure? This will delete all project data! [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Stopping and removing containers..."
            docker compose down -v --remove-orphans
            echo "Removing project images..."
            docker compose down --rmi local 2>/dev/null || true
            echo -e "${RED}✅ Project cleanup completed!${NC}"
        else
            echo "Operation cancelled."
        fi
        ;;
    urls)
        show_urls
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac
