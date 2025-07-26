# @renanteixeira/odoo-await

Enhanced Odoo API client with comprehensive security validations - Fork of [odoo-await](https://github.com/vettloffah/odoo-await)

[![npm version](https://badge.fury.io/js/%40renanteixeira%2Fodoo-await.svg)](https://badge.fury.io/js/%40renanteixeira%2Fodoo-await)
[![Tests](https://img.shields.io/badge/tests-37%20passing-brightgreen.svg)](https://github.com/renanteixeira/odoo-await)

## 🔒 Security Enhanced Fork

This is an enhanced version of the original `odoo-await` library with comprehensive security improvements, input validation, and robust error handling.

### 🆚 What's New vs Original

| Feature | Original | Enhanced Fork |
|---------|----------|---------------|
| Input Validation | ❌ None | ✅ Comprehensive |
| Error Sanitization | ❌ Exposes sensitive data | ✅ Sanitized messages |
| Connection Timeout | ❌ Can hang indefinitely | ✅ 30-second timeout |
| Security Tests | ❌ None | ✅ 30 comprehensive tests |
| Type Checking | ❌ Basic | ✅ Strict validation |
| SQL Injection Prevention | ❌ None | ✅ Parameter sanitization |
| Documentation | ❌ Basic | ✅ Comprehensive |

## 📦 Installation

```bash
npm install @renanteixeira/odoo-await
```

## 🚀 Quick Start

```javascript
const OdooAwait = require('@renanteixeira/odoo-await');

const odoo = new OdooAwait({
  baseUrl: 'https://your-odoo-server.com',
  port: 8069,
  db: 'your_database',
  username: 'your_username', 
  password: 'your_password'
});

// Always connect first
await odoo.connect();

// Create a record
const recordId = await odoo.create('res.partner', {
  name: 'John Doe',
  email: 'john@example.com'
});

// Read records
const records = await odoo.read('res.partner', [recordId]);
```

## 🔒 Security Features

### Input Validation
All methods now validate inputs before processing:

```javascript
// Validates required parameters
new OdooAwait({
  db: '',        // ❌ Throws: "Database name is required and must be a non-empty string"
  username: '',  // ❌ Throws: "Username is required and must be a non-empty string" 
  password: '',  // ❌ Throws: "Password is required and must be a string"
});

// Validates record IDs
await odoo.read('res.partner', -1);    // ❌ Throws: "Record ID must be a positive integer"
await odoo.update('', 123, {});        // ❌ Throws: "Model name is required and must be a non-empty string"
```

### Error Sanitization
Sensitive information is never exposed in error messages:

```javascript
// Before (Original)
Error: Authentication failed for user 'admin' with password 'secret123'

// After (Enhanced)
Error: Authentication failed. Please check your credentials.
```

### Connection Timeout
Prevents resource exhaustion with automatic timeouts:

```javascript
// Automatically times out after 30 seconds instead of hanging indefinitely
await odoo.connect(); // Times out if unreachable
```

## 🧪 Testing

```bash
# Set environment variables
export ODOO_DB=your_test_database
export ODOO_USER=admin
export ODOO_PW=your_password
export ODOO_BASE_URL=http://localhost
export ODOO_PORT=8069

# Run all tests
npm test

# Run only security tests
npx mocha test/integration.enhanced.test.js

# Run only compatibility tests
npx mocha test/integration.test.js
```

## 📊 Test Coverage

- ✅ **37 tests passing** (30 security + 7 compatibility)
- ✅ Constructor validation (5 tests)
- ✅ Connection security (2 tests)
- ✅ CRUD method validation (21 tests)
- ✅ Security & performance (4 tests)
- ✅ Backward compatibility (7 tests)

## 🔄 Migration from Original

This fork is **100% backward compatible**. Simply update your import:

```javascript
// Before
const OdooAwait = require('odoo-await');

// After
const OdooAwait = require('@renanteixeira/odoo-await');

// All existing code works unchanged!
```

## 📚 API Documentation

All original API methods are preserved with enhanced validation:

### Constructor
```javascript
new OdooAwait(options)
```

### Methods
- `connect()` - Authenticate and get UID
- `create(model, params, externalId?, moduleName?)` - Create record
- `read(model, recordId, fields?)` - Read records  
- `update(model, recordId, params)` - Update record
- `delete(model, recordId)` - Delete record
- `search(model, domain?, fields?, opts?)` - Search records
- `searchRead(model, domain?, fields?, opts?)` - Search and read records

See [SECURITY_IMPROVEMENTS.md](./SECURITY_IMPROVEMENTS.md) for detailed security documentation.

## 🙏 Credits

This enhanced fork is based on the original excellent work by [Charlie Wettlaufer](https://github.com/vettloffah). The original `odoo-await` library provided the solid foundation that made these security enhancements possible.

- **Original Author**: Charlie Wettlaufer ([@vettloffah](https://github.com/vettloffah))
- **Original Repository**: [odoo-await](https://github.com/vettloffah/odoo-await)
- **Enhanced Fork**: Renan Teixeira ([@renanteixeira](https://github.com/renanteixeira))

## 📄 License

ISC License (same as original)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🔗 Links

- [Original odoo-await](https://github.com/vettloffah/odoo-await)
- [Security Documentation](./SECURITY_IMPROVEMENTS.md)
- [NPM Package](https://www.npmjs.com/package/@renanteixeira/odoo-await)
