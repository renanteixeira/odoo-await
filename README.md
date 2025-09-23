# @renanteixeira/odoo-await

**Enhanced Odoo API client with comprehensive security validations**

[![npm version](https://badge.fury.io/js/%40renanteixeira%2Fodoo-await.svg)](https://badge.fury.io/js/%40renanteixeira%2Fodoo-await)
[![Tests](https://img.shields.io/badge/tests-37%20passing-brightgreen.svg)](https://github.com/renanteixeira/odoo-await)
[![Security](https://img.shields.io/badge/security-enhanced-brightgreen.svg)](https://github.com/renanteixeira/odoo-await)
[![Odoo 12.0](https://img.shields.io/badge/Odoo-12.0-brightgreen.svg)](https://github.com/renanteixeira/odoo-await)
[![Odoo 13.0](https://img.shields.io/badge/Odoo-13.0-brightgreen.svg)](https://github.com/renanteixeira/odoo-await)
[![Odoo 14.0](https://img.shields.io/badge/Odoo-14.0-brightgreen.svg)](https://github.com/renanteixeira/odoo-await)
[![Odoo 15.0](https://img.shields.io/badge/Odoo-15.0-brightgreen.svg)](https://github.com/renanteixeira/odoo-await)
[![Odoo 16.0](https://img.shields.io/badge/Odoo-16.0-brightgreen.svg)](https://github.com/renanteixeira/odoo-await)
[![Odoo 17.0](https://img.shields.io/badge/Odoo-17.0-brightgreen.svg)](https://github.com/renanteixeira/odoo-await)
[![Odoo 18.0](https://img.shields.io/badge/Odoo-18.0-brightgreen.svg)](https://github.com/renanteixeira/odoo-await)
[![Odoo 19.0](https://img.shields.io/badge/Odoo-19.0-brightgreen.svg)](https://github.com/renanteixeira/odoo-await)

This is an **enhanced and security-focused fork** of the original [odoo-await](https://github.com/vettloffah/odoo-await) library, built with promises for async/await usage. Features comprehensive input validation, error sanitization, timeout handling, and robust security improvements while maintaining 100% backward compatibility.

**✨ NEW: Multi-Version Docker Environment** - Test your code against Odoo versions 12.0 through 19.0 simultaneously! See [Multi-Version Setup Guide](./MULTI_VERSION_README.md).

## 🔒 Why This Enhanced Fork?

| Feature | Original `odoo-await` | This Enhanced Fork |
|---------|----------------------|-------------------|
| Input Validation | ❌ None | ✅ Comprehensive |
| Error Sanitization | ❌ Exposes sensitive data | ✅ Sanitized messages |
| Connection Timeout | ❌ Can hang indefinitely | ✅ 30-second timeout |
| Security Tests | ❌ Basic (7 tests) | ✅ Comprehensive (37 tests) |
| SQL Injection Prevention | ❌ None | ✅ Parameter sanitization |
| Type Checking | ❌ Basic | ✅ Strict validation |
| Odoo Version Support | ❌ Single version testing | ✅ Multi-version (12.0-19.0) |
| Docker Environment | ❌ Basic setup | ✅ Multi-version testing environment |
| Last Updated | ❌ Over 1 year ago | ✅ Actively maintained |

## 📦 Installation

```bash
npm install @renanteixeira/odoo-await
```

## 🚀 Quick Start

```javascript
const Odoo = require("@renanteixeira/odoo-await");

const odoo = new Odoo({
  baseUrl: "https://yourdomain.odoo.com",
  port: 8069, // optional, defaults to protocol default
  db: "your_database",
  username: "your_username",
  password: "your_password"
});

// Always connect first
await odoo.connect();

// Create a record with validation
const partnerId = await odoo.create("res.partner", {
  name: "John Doe",
  email: "john@example.com"
});

console.log(`Partner created with ID ${partnerId}`);
```

## 🔒 Security Features

### Input Validation
All methods now validate inputs before processing:

```javascript
// Constructor validation
new Odoo({
  db: '',        // ❌ Throws: "Database name is required and must be a non-empty string"
  username: '',  // ❌ Throws: "Username is required and must be a non-empty string" 
  password: '',  // ❌ Throws: "Password is required and must be a string"
});

// Method parameter validation
await odoo.read('res.partner', -1);    // ❌ Throws: "Record ID must be a positive integer"
await odoo.update('', 123, {});        // ❌ Throws: "Model name is required and must be a non-empty string"
```

### Error Sanitization
Sensitive information is never exposed:

```javascript
// Before (Original): Exposes password
Error: Authentication failed for user 'admin' with password 'secret123'

// After (Enhanced): Sanitized
Error: Authentication failed. Please check your credentials.
```

### Connection Timeout
Prevents resource exhaustion:

```javascript
// Automatically times out after 30 seconds instead of hanging indefinitely
await odoo.connect(); // Won't hang on unreachable servers
```
```

## ⚙️ Configuration

```javascript  
const odoo = new Odoo({
  baseUrl: "https://yourdomain.odoo.com",
  port: 8069,        // Optional - see port resolution below
  db: "your_database",
  username: "your_username", 
  password: "your_password"
});
```

### Port Resolution (Enhanced)
From version 3.x onwards, port resolution follows this priority:

1. `port` option, if explicitly provided
2. Port number in URL, if provided (e.g., `http://example.com:8069`)  
3. Default port for protocol (443 for https, 80 for http)

### Odoo.sh Development Example
```javascript
const odoo = new Odoo({
  baseUrl: "https://some-database-name-5-29043948.dev.odoo.com/",
  db: "some-database-name-5-29043948",
  username: "myusername",
  password: "somepassword"
});
```

## 🔧 System Requirements

- **Node.js**: 11.16+
- **Odoo**: 12.0+
- **NPM/Yarn**: Latest stable

## 📚 API Methods

All methods include comprehensive input validation and error handling.

### odoo.connect()

Establishes connection and authenticates with Odoo server. **Must be called before other methods.**

```javascript
await odoo.connect(); // Returns UID on success, throws on failure
```

**Enhanced Security Features:**
- ✅ 30-second connection timeout
- ✅ Sanitized error messages (no password exposure)
- ✅ Validates authentication response

### odoo.execute_kw(model, method, params)

Low-level method for direct Odoo XML-RPC calls. This method is wrapped by the convenience methods below.
Reference: [Odoo External API](https://www.odoo.com/documentation/14.0/webservices/odoo.html)

```javascript
const result = await odoo.execute_kw('res.partner', 'search', [[['is_company', '=', true]]]);
```

### odoo.action(model, action, recordId)

Execute a server action on a record or set of records. Returns **false** on success.

```javascript
await odoo.action("account.move", "action_post", [126996, 126995]);
```

**Enhanced Security Features:**
- ✅ Model name validation
- ✅ Record ID validation (positive integers only)

## 🔧 CRUD Operations

### odoo.create(model, params, externalId, moduleName)

**Creates a new record and returns the ID.**

```javascript
const partnerId = await odoo.create("res.partner", { 
  name: "John Doe",
  email: "john@example.com" 
});

// With external ID for easier reference
const partnerIdWithExternal = await odoo.create("res.partner", 
  { name: "Jane Doe" }, 
  "partner_jane", 
  "my_module"
);
```

**Enhanced Security Features:**
- ✅ Model name validation (non-empty string required)
- ✅ Parameters object validation (must be valid object)
- ✅ External ID validation (non-empty string if provided)
- ✅ Module name validation (non-empty string if provided)

### odoo.read(model, recordId, fields)

**Fetches record data by ID(s). Returns an array.**

```javascript
// Read multiple records with specific fields
const records = await odoo.read("res.partner", [54, 1568], ["name", "email"]);
console.log(records);
// [{ id: 54, name: 'John Doe', email: 'john@example.com' }, ...]

// Read single record with all fields
const record = await odoo.read("res.partner", 54);

// Fields parameter can be a string or array
const recordsWithName = await odoo.read("res.partner", [54], "name");
```

**Enhanced Security Features:**
- ✅ Model name validation (non-empty string required)
- ✅ Record ID validation (positive integers only)
- ✅ Fields parameter validation (array of strings or string)
- ✅ Handles non-existent records gracefully

### odoo.update(model, recordId, params)

**Updates existing record(s). Returns true if successful.**

```javascript
// Update single record
const updated = await odoo.update("res.partner", 54, {
  street: "334 Living Astro Blvd.",
  city: "New York"
});
console.log(updated); // true

// Update multiple records
await odoo.update("res.partner", [54, 55], { active: true });
```

**Enhanced Security Features:**
- ✅ Model name validation (non-empty string required)
- ✅ Record ID validation (positive integers, single or array)
- ✅ Parameters object validation (must be valid object)
- ✅ Handles concurrent updates safely

### odoo.delete(model, recordId)

**Deletes record(s). Returns true if successful.**

```javascript
// Delete single record
const deleted = await odoo.delete("res.partner", 54);
console.log(deleted); // true

// Delete multiple records
await odoo.delete("res.partner", [54, 55, 56]);
```

**Enhanced Security Features:**
- ✅ Model name validation (non-empty string required)
- ✅ Record ID validation (positive integers, single or array)
- ✅ Handles deletion of non-existent records gracefully

## 🔗 Many2many and One2many Fields

Odoo handles related field lists in a special way. You can choose to:

1. **`add`** - Link an existing record to the list using the record ID
2. **`update`** - Update an existing record in the record set using ID and new values  
3. **`create`** - Create a new record on the fly and add it to the list using values
4. `replace` all records with other record(s) without deleting the replaced ones from database - using a list of IDs
5. `delete` one or multiple records from the database

In order to use any of these actions on a field, supply an object as the field value with the following parameters:

- **action** (required) - one of the strings from above
- **id** (required for actions that use id(s) ) - can usually be an array, or a single number
- **value** (required for actions that update or create new related records) - can usually be an single value object, or
  an array of value objects if creating mutliple records

#### Examples

```js
// create new realted records on the fly
await odoo.update("res.partner", 278, {
  category_id: {
    action: "create",
    value: [{ name: "a new category" }, { name: "another new category" }],
  },
});

// update a related record in the set
await odoo.update("res.partner", 278, {
  category_id: {
    action: "update",
    id: 3,
    value: { name: "Updated category" },
  },
});

// add existing records to the set
await odoo.update("res.partner", 278, {
  category_id: {
    action: "add",
    id: 5, // or an array of numbers
  },
});

// remove from the set but don't delete from database
await odoo.update("res.partner", 278, {
  category_id: {
    action: "remove",
    id: 5, // or an array of numbers
  },
});

// remove record and delete from database
await odoo.update("res.partner", 278, {
  category_id: {
    action: "delete",
    id: 5, // or an array of numbers
  },
});

// clear all records from set, but don't delete
await odoo.update("res.partner", 278, {
  category_id: {
    action: "clear",
  },
});

// replace records in set with other existing records
await odoo.update("res.partner", 278, {
  category_id: {
    action: "replace",
    id: [3, 12, 6], // or a single number
  },
});

// You can also just do a regular update with an array of IDs, which will accomplish same as above
await odoo.update("res.partner", 278, {
  category_id: [3, 12, 16],
});
```

## 🔍 Search Methods

### odoo.search(model, domain, opts)

**Searches and returns record IDs that match the domain criteria.**

```javascript
// Search with object domain (automatically converted to Odoo format)
const recordIds = await odoo.search('res.partner', {
  country_id: 'United States',
  is_company: true
});
console.log(recordIds); // [14, 26, 33, ...]

// Search with complex domain array
const recordIds = await odoo.search('res.partner', [
  ['name', 'ilike', 'john'],
  ['active', '=', true]
]);

// Return all records (omit domain)
const allRecords = await odoo.search('res.partner');

// With options
const recordIds = await odoo.search('res.partner', {}, {
  limit: 10,
  offset: 20,
  order: 'name DESC'
});
```

**Enhanced Security Features:**
- ✅ Model name validation (non-empty string required)
- ✅ Domain filter validation and sanitization
- ✅ Options parameter validation (limit, offset must be positive integers)
- ✅ Handles empty results gracefully

### odoo.searchRead(model, domain, fields, opts)

**Searches for matching records and returns record data with specified fields.**

```javascript
// Search and read with specific fields
const records = await odoo.searchRead(
  'res.partner',
  { country_id: 'United States' },
  ['name', 'city', 'email'],
  { 
    limit: 5, 
    offset: 10, 
    order: 'name DESC',
    context: { lang: 'en_US' }
  }
);
console.log(records); // [{ id: 5, name: 'John Doe', city: 'Los Angeles', email: '...' }, ...]

// Search all records with minimal fields
const records = await odoo.searchRead('res.partner', {}, ['name']);

// Empty domain to get all records
const allRecords = await odoo.searchRead('res.partner');
```

**Enhanced Security Features:**
- ✅ Model name validation (non-empty string required)
- ✅ Domain filter validation and sanitization
- ✅ Fields parameter validation (array of strings)
- ✅ Options validation (limit/offset must be positive integers)
- ✅ Complex domain filter safety checks

## 🔍 Complex Domain Filters

Use domain filter arrays for advanced search criteria with operators like `<`, `>`, `like`, `=like`, `ilike`, `in`, etc.
Reference: [Odoo Domain API Docs](https://www.odoo.com/documentation/14.0/reference/orm.html#reference-orm-domains)

Supports logical operators: OR `"|"`, AND `"&"`, NOT `"!"`.

```javascript
// Complex domain examples
const records = await odoo.searchRead('res.partner', [
  ['name', 'ilike', 'john'],
  ['create_date', '>', '2023-01-01'],
  ['active', '=', true]
]);

// Using logical operators
const records = await odoo.searchRead('res.partner', [
  '|', // OR operator
  ['email', 'ilike', '@gmail.com'],
  ['email', 'ilike', '@yahoo.com']
]);

// Complex logical combinations
const records = await odoo.searchRead('res.partner', [
  '&', // AND operator
  ['is_company', '=', false],
  '|', // OR operator
  ['city', '=', 'New York'],
  ['city', '=', 'Los Angeles']
]);
```

```js
// single domain filter array
const recordIds = await odoo.search("res.partner", ["name", "=like", "john%"]);

// or a multiple domain filter array (array of arrays)
const recordIds = await odoo.search("res.partner", [
  ["name", "=like", "john%"],
  ["sale_order_count", ">", 1],
]);

// logical operator OR
// email is "charlie@example.com" OR name includes "charlie"
const records = await odoo.searchRead("res.partner", [
  "|",
  ["email", "=", "charlie@example.com"],
  ["name", "ilike", "charlie"],
]);
```

#### odoo.getFields(model, attributes)

Returns detailed list of fields for a model, filtered by attributes. e.g., if you only want to know if fields are required you could call:

```js
const fields = await odoo.getFields("res.partner", ["required"]);
console.log(fields);
```

## Working With External Identifiers

External ID's can be important when using the native Odoo import feature with CSV files to sync data between systems, or updating
records using your own unique identifiers instead of the Odoo database ID.

External ID's are created automatically when exporting or importing data using the Odoo
_user interface_, but when working with the API this must be done intentionally.

External IDs are managed separately in the `ir.model.data` model in the database - so these methods make working with
them easier.

#### Module names with external ID's

External ID's require a module name along with the ID. If you don't supply a module name when creating an external ID
with this library, the default module name '**api**' will be used.
What that means is that `'some-unique-identifier'` will live in the database as
`'__api__.some-unique-identifier'`. You do _not_ need to supply the module name when searching using externalId.

#### create(model, params, externalId, moduleName)

If creating a record, simply supply the external ID as the third parameter, and a module name as an optional 4th parameter.
This example creates a record and an external ID in one method. (although it makes two separate `create` calls to the
database under the hood).

```js
const record = await odoo.create(
  "product.product",
  { name: "new product" },
  "some-unique-identifier"
);
```

#### createExternalId(model, recordId, externalId)

For records that are already created without an external ID, you can link an external ID to it.

```js
await odoo.createExternalId("product.product", 76, "some-unique-identifier");
```

#### readByExternalId(externalId, fields);

Find a record by the external ID, and return whatever fields you want. Leave the `fields` parameter empty to return all
fields.

```js
const record = await odoo.readByExternalId("some-unique-identifier", [
  "name",
  "email",
]);
```

#### updateByExternalId(externalId, params)

```js
const updated = await odoo.updateByExternalId("some-unique-identifier", {
  name: "space shoe",
  price: 65479.99,
});
```

## Testing

The default test will run through basic CRUD functions, creating a `res.partner` record, updating it, reading it, and deleting it. Uses Mocha and Should as dependencies.

Pass the variables in command line with environment variables:

```shell script
$ ODOO_DB=mydatabase ODOO_USER=myusername ODOO_PW=mypassword ODOO_PORT=8080 ODOO_BASE_URL=https://myodoo.com npm test
```

- [Odoo Docs](https://www.odoo.com/documentation/14.0)
- [Odoo External API](https://www.odoo.com/documentation/14.0/webservices/odoo.html)

## 🧪 Testing

This enhanced fork includes a comprehensive test suite with 37 tests covering security validations and backward compatibility.

### Running Tests

```bash
# Set environment variables
export ODOO_DB=your_test_database
export ODOO_USER=admin
export ODOO_PW=your_password
export ODOO_BASE_URL=http://localhost
export ODOO_PORT=8069

# Run all tests (30 security + 7 compatibility)
npm test

# Run only security tests
npx mocha test/integration.enhanced.test.js

# Run only compatibility tests  
npx mocha test/integration.test.js
```

### Test Coverage

- ✅ **Constructor Validation** (5 tests) - Parameter validation, URL parsing, port configuration
- ✅ **Connection Security** (2 tests) - Timeout handling, authentication failure
- ✅ **CRUD Method Validation** (21 tests) - Parameter validation for all CRUD operations
- ✅ **Security Tests** (2 tests) - Error sanitization, malformed input handling  
- ✅ **Performance Tests** (1 test) - Bulk operations efficiency
- ✅ **Backward Compatibility** (7 tests) - Ensures original functionality is preserved

## 🔄 Migration from Original

This fork is **100% backward compatible**. Simply update your installation:

```bash
# Replace original package
npm uninstall odoo-await
npm install @renanteixeira/odoo-await

# Update your imports
const Odoo = require('@renanteixeira/odoo-await'); // Was: require('odoo-await')

# All existing code works unchanged!
```

### Benefits of Migrating

- 🔒 **Enhanced Security**: Input validation and error sanitization
- ⏱️ **Reliability**: Connection timeouts prevent hanging
- 🧪 **Quality**: 30 additional security tests  
- 📚 **Documentation**: Comprehensive security documentation
- 🔧 **Maintenance**: Actively maintained with updated dependencies

## 🧪 Testing

This enhanced fork includes a comprehensive test suite with 37 tests covering security validations and backward compatibility.

### Running Tests

```bash
# Set environment variables
export ODOO_DB=your_test_database
export ODOO_USER=admin
export ODOO_PW=your_password
export ODOO_BASE_URL=http://localhost
export ODOO_PORT=8069

# Run all tests (30 security + 7 compatibility)
npm test

# Run only security tests
npx mocha test/integration.enhanced.test.js

# Run only compatibility tests  
npx mocha test/integration.test.js
```

### Test Coverage

- ✅ **Constructor Validation** (5 tests) - Parameter validation, URL parsing, port configuration
- ✅ **Connection Security** (2 tests) - Timeout handling, authentication failure
- ✅ **CRUD Method Validation** (21 tests) - Parameter validation for all CRUD operations
- ✅ **Security Tests** (2 tests) - Error sanitization, malformed input handling  
- ✅ **Performance Tests** (1 test) - Bulk operations efficiency
- ✅ **Backward Compatibility** (7 tests) - Ensures original functionality is preserved

## 🔄 Migration from Original

This fork is **100% backward compatible**. Simply update your installation:

```bash
# Replace original package
npm uninstall odoo-await
npm install @renanteixeira/odoo-await

# Update your imports
const Odoo = require('@renanteixeira/odoo-await'); // Was: require('odoo-await')

// All existing code works unchanged!
```

### Benefits of Migrating

- 🔒 **Enhanced Security**: Input validation and error sanitization
- ⏱️ **Reliability**: Connection timeouts prevent hanging
- 🧪 **Quality**: 30 additional security tests  
- 📚 **Documentation**: Comprehensive security documentation
- 🔧 **Maintenance**: Actively maintained with updated dependencies

## 🏗️ Working with External Identifiers

Create, search, read, and update records using external IDs instead of database IDs:

```javascript
// Create with external ID
const recordId = await odoo.create('res.partner', 
  { name: 'John Doe' }, 
  'partner_john_doe',  // external ID
  'my_module'          // module name
);

// Search by external ID
const record = await odoo.searchByExternalId('my_module.partner_john_doe');

// Update by external ID
await odoo.updateByExternalId('my_module.partner_john_doe', { 
  email: 'john.new@example.com' 
});
```

## 🙏 Credits & License

This enhanced fork is based on the excellent foundation provided by the original `odoo-await` library.

### Original Author
- **Charlie Wettlaufer** ([@vettloffah](https://github.com/vettloffah))
- **Original Repository**: [odoo-await](https://github.com/vettloffah/odoo-await)

### Enhanced Fork
- **Renan Teixeira** ([@renanteixeira](https://github.com/renanteixeira))
- **Enhanced Repository**: [odoo-await](https://github.com/renanteixeira/odoo-await)
- **NPM Package**: [@renanteixeira/odoo-await](https://www.npmjs.com/package/@renanteixeira/odoo-await)

### License

**ISC License**

Copyright (c) 2020 Charlie Wettlaufer (Original)  
Copyright (c) 2025 Renan Teixeira (Enhanced Fork)

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

### Development Setup

```bash
git clone https://github.com/renanteixeira/odoo-await.git
cd odoo-await
npm install

# Quick start with multi-version environment
./manage-odoo.sh init

# Or setup single version for basic development (Odoo 12.0)
cd odoo-local/12.0
docker-compose up -d

# Run tests against all versions
./manage-odoo.sh test

# Run tests against single version
npm test
```

## 🐳 Multi-Version Docker Environment

This project includes a comprehensive Docker setup for testing against multiple Odoo versions simultaneously:

- **Supported Versions**: Odoo 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0
- **Automated Setup**: One command initialization
- **Individual Databases**: Each version has its own PostgreSQL database
- **Port Mapping**: Sequential ports (12069, 13069, 14069, etc.)

### Quick Commands

```bash
# Initialize all Odoo versions (first time)
./manage-odoo.sh init

# Start all services
./manage-odoo.sh start

# Test library against all versions
./manage-odoo.sh test

# View all access URLs
./manage-odoo.sh urls

# Check services status
./manage-odoo.sh status
```

For detailed setup instructions, see [Multi-Version Setup Guide](./MULTI_VERSION_README.md).

## 📚 Additional Resources

- [📋 **Changelog**](./CHANGELOG.md) - Complete version history and release notes
- [🐳 Multi-Version Docker Setup Guide](./MULTI_VERSION_README.md)
- [🔒 Security Improvements Documentation](./SECURITY_IMPROVEMENTS.md)
- [📖 Original odoo-await Documentation](https://github.com/vettloffah/odoo-await)
- [🔗 Odoo External API Documentation](https://www.odoo.com/documentation/14.0/webservices/odoo.html)
- [🔍 Odoo Domain Filters Reference](https://www.odoo.com/documentation/14.0/reference/orm.html#reference-orm-domains)

---

**Made with ❤️ for the Odoo community**
