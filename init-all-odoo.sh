#!/bin/bash

# Script to initialize all Odoo databases
# Usage: ./init-all-odoo.sh

set -e

echo "🚀 Starting all Odoo services..."

# Start PostgreSQL and wkhtmltopdf first
echo "📦 Starting support services..."
docker compose up -d postgres wkhtml

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL..."
for i in {1..30}; do
    if docker compose exec postgres pg_isready -U postgres >/dev/null 2>&1; then
        echo "✅ PostgreSQL is ready!"
        break
    fi
    sleep 2
    if [ $i -eq 30 ]; then
        echo "❌ PostgreSQL did not become ready in 60 seconds"
        exit 1
    fi
done

# Check if odoo user exists, create if necessary
echo "🔧 Configuring PostgreSQL user..."
docker compose exec postgres psql -U postgres -c "SELECT 1 FROM pg_roles WHERE rolname='odoo'" | grep -q 1 || {
    echo "📝 Creating user 'odoo'..."
    docker compose exec postgres psql -U postgres -c "CREATE USER odoo WITH CREATEDB PASSWORD 'odoo';"
    echo "✅ User 'odoo' created successfully!"
}

# Inicializar bancos de dados para cada versão do Odoo
versions=(12 13 14 15 16 17 18)

for version in "${versions[@]}"; do
    echo "🔧 Initializing Odoo ${version}.0..."
    
    # Create database if it doesn't exist
    if docker compose exec postgres psql -U postgres -lqt | cut -d \| -f 1 | grep -qw "odoo${version}"; then
        echo "📝 Database odoo${version} already exists, skipping creation..."
    else
        echo "📝 Creating database odoo${version}..."
        docker compose exec postgres createdb -U postgres -O odoo odoo${version}
        echo "✅ Database odoo${version} created!"
    fi
    
    # Initialize Odoo with base module
    docker compose run --rm odoo${version} odoo \
        --database=odoo${version} \
        --db_user=odoo \
        --db_password=odoo \
        --db_host=postgres \
        --init=base \
        --stop-after-init \
        --without-demo=False
        
    echo "✅ Odoo ${version}.0 initialized successfully!"
done

# Start all Odoo services
echo "🚀 Starting all Odoo services..."
docker compose up -d

echo "🎉 All Odoo services are running!"
echo ""
echo "📋 Available ports:"
echo "   Odoo 12.0: http://localhost:12069"
echo "   Odoo 13.0: http://localhost:13069"
echo "   Odoo 14.0: http://localhost:14069"
echo "   Odoo 15.0: http://localhost:15069"
echo "   Odoo 16.0: http://localhost:16069"
echo "   Odoo 17.0: http://localhost:17069"
echo "   Odoo 18.0: http://localhost:18069"
echo ""
echo "🔐 Default credentials: admin/admin"
echo "💾 PostgreSQL: localhost:5432 (odoo/odoo)"
