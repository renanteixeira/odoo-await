#!/bin/bash

# Script de conveniência para gerenciar o ambiente Docker do Odoo 12.0

COMPOSE_DIR="./odoo-local/12.0"

case "$1" in
    start)
        echo "🚀 Iniciando stack Odoo 12.0..."
        cd $COMPOSE_DIR && docker compose up -d
        echo "✅ Stack iniciado. Aguarde alguns segundos para inicialização completa."
        echo "🌐 Odoo: http://localhost:12069 (admin/admin)"
        ;;
    stop)
        echo "🛑 Parando stack Odoo 12.0..."
        cd $COMPOSE_DIR && docker compose down
        echo "✅ Stack parado."
        ;;
    restart)
        echo "🔄 Reiniciando stack Odoo 12.0..."
        cd $COMPOSE_DIR && docker compose restart
        echo "✅ Stack reiniciado."
        ;;
    logs)
        echo "📋 Exibindo logs do Odoo..."
        cd $COMPOSE_DIR && docker compose logs -f odoo
        ;;
    status)
        echo "📊 Status dos containers:"
        cd $COMPOSE_DIR && docker compose ps
        ;;
    test)
        echo "🧪 Executando testes do odoo-await..."
        ODOO_DB=test_odoo_12 ODOO_USER=admin ODOO_PW=admin ODOO_PORT=12069 ODOO_BASE_URL=http://localhost npm test
        ;;
    clean)
        echo "🧹 Limpando volumes e reiniciando..."
        cd $COMPOSE_DIR && docker compose down -v && docker compose up -d
        echo "✅ Ambiente limpo e reiniciado."
        ;;
    *)
        echo "🔧 Uso: $0 {start|stop|restart|logs|status|test|clean}"
        echo ""
        echo "Comandos disponíveis:"
        echo "  start   - Inicia o stack Docker"
        echo "  stop    - Para o stack Docker"
        echo "  restart - Reinicia o stack Docker"
        echo "  logs    - Mostra logs do Odoo em tempo real"
        echo "  status  - Exibe status dos containers"
        echo "  test    - Executa testes do odoo-await"
        echo "  clean   - Limpa volumes e reinicia"
        exit 1
        ;;
esac
