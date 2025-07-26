# 🐳 Ambiente Odoo Multi-Versão

Este ambiente Docker permite executar simultaneamente todas as versões do Odoo (12, 13, 14, 15, 16, 17, 18) para testes de compatibilidade da biblioteca `odoo-await`.

## 🚀 Início Rápido

### 1. Inicializar o ambiente (primeira vez)
```bash
./manage-odoo.sh init
```

### 2. Executar testes em todas as versões
```bash
./manage-odoo.sh test
```

## 📋 Comandos Disponíveis

```bash
./manage-odoo.sh [comando]
```

| Comando | Descrição |
|---------|-----------|
| `init` | Inicializar todos os serviços Odoo (primeira vez) |
| `start` | Iniciar todos os serviços |
| `stop` | Parar todos os serviços |
| `restart` | Reiniciar todos os serviços |
| `status` | Mostrar status dos serviços |
| `test` | Executar testes em todas as versões |
| `logs` | Mostrar logs de todos os serviços |
| `clean` | Limpar containers, volumes e imagens do projeto |
| `urls` | Mostrar URLs de acesso |

## 🌐 URLs de Acesso

| Versão | URL | WebSocket |
|--------|-----|-----------|
| Odoo 12.0 | http://localhost:12069 | ws://localhost:12072 |
| Odoo 13.0 | http://localhost:13069 | ws://localhost:13072 |
| Odoo 14.0 | http://localhost:14069 | ws://localhost:14072 |
| Odoo 15.0 | http://localhost:15069 | ws://localhost:15072 |
| Odoo 16.0 | http://localhost:16069 | ws://localhost:16072 |
| Odoo 17.0 | http://localhost:17069 | ws://localhost:17072 |
| Odoo 18.0 | http://localhost:18069 | ws://localhost:18072 |

**Credenciais padrão:** `admin/admin`

## 🛠️ Serviços de Apoio

- **PostgreSQL**: `localhost:5432` (odoo/odoo)
- **wkhtmltopdf**: `http://localhost:8080`

## 💡 Exemplos de Uso

### Testar versão específica manualmente
```javascript
const OdooAwait = require('@renanteixeira/odoo-await');

// Para Odoo 15.0
const odoo = new OdooAwait({
    baseUrl: 'http://localhost:15069',
    db: 'odoo15',
    username: 'admin',
    password: 'admin'
});

await odoo.connect();
const partners = await odoo.searchRead('res.partner', {}, ['name', 'email']);
```

### Executar npm test contra versão específica
```bash
# Testar contra Odoo 17.0
ODOO_DB=odoo17 ODOO_USER=admin ODOO_PW=admin ODOO_BASE_URL=http://localhost:17069 npm test
```

## 📊 Estrutura dos Bancos

Cada versão do Odoo tem seu próprio banco de dados:
- `odoo12` - Banco para Odoo 12.0
- `odoo13` - Banco para Odoo 13.0  
- `odoo14` - Banco para Odoo 14.0
- `odoo15` - Banco para Odoo 15.0
- `odoo16` - Banco para Odoo 16.0
- `odoo17` - Banco para Odoo 17.0
- `odoo18` - Banco para Odoo 18.0

## 🧹 Limpeza e Manutenção

### Reiniciar tudo do zero
```bash
./manage-odoo.sh clean
./manage-odoo.sh init
```

### Ver logs de um serviço específico
```bash
docker compose logs odoo15
```

### Conectar ao PostgreSQL
```bash
docker compose exec postgres psql -U odoo
```

## ⚠️ Segurança

### Comando `clean`
O comando `./manage-odoo.sh clean` remove **apenas** os recursos Docker deste projeto:
- Containers do docker-compose.yml
- Volumes definidos no projeto
- Imagens locais do projeto

**NÃO** afeta outros containers ou imagens Docker do sistema.

## ⚡ Performance

O ambiente usa um PostgreSQL compartilhado para otimizar recursos. Cada versão do Odoo mantém seu próprio banco de dados e volume de dados, garantindo isolamento completo.

## 🔧 Troubleshooting

### Serviço não inicia
```bash
./manage-odoo.sh status
./manage-odoo.sh logs
```

### Porta em uso
Se alguma porta estiver em uso, edite o `docker-compose.yml` e altere as portas dos serviços conflitantes.

### Problemas de memória
O ambiente executa 7 instâncias do Odoo simultaneamente. Certifique-se de ter pelo menos 8GB de RAM disponível.
