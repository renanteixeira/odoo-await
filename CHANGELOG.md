# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.8.0] - 2025-09-22

### 🚀 Added
- **ESM Support**: Full ES modules support for modern Node.js environments and server-side rendering
- **Conditional Exports**: Added `exports` field in package.json for dual CommonJS/ESM compatibility
- **Module Field**: Added `module` field pointing to `lib/index.mjs` for bundler optimization
- **Browser Detection**: Added runtime check to prevent browser usage with clear error message

### ✅ Verified
- **Backend Compatibility**: All existing CommonJS usage remains unchanged
- **ESM Functionality**: Tested with Node.js ESM and server-side bundlers
- **No Breaking Changes**: Existing Node.js backend applications continue to work without modifications
- **Browser Safety**: Prevents accidental browser usage with informative error messages

### 📚 Documentation
- **README.md**: Added dedicated "Frontend Usage (ESM)" section with examples for:
  - Next.js API routes
  - Server-side rendering (SSR) with React
  - Express.js with ESM
  - Nuxt.js server middleware
- **Environment Clarification**: Clear documentation that library is for backend/Node.js only
- **Usage Examples**: Practical code samples for server-side frameworks

### 🔒 Security
### 🔒 Security
- **Browser Protection**: Runtime detection prevents insecure browser usage with informative error messages
- **Dynamic Imports**: xmlrpc library loaded only when needed, preventing browser import errors
- **Clear Error Messages**: Helpful guidance when used incorrectly in browser environments
- **Environment Validation**: Constructor validates execution environment before proceeding
- **Environment Validation**: Constructor validates execution environment before proceeding

## [3.7.0] - 2025-09-22

### 🚀 Added
- **Odoo 19.0 Support**: Full compatibility with Odoo 19.0, including Docker environment and comprehensive testing
- **Updated Multi-Version Environment**: Extended Docker setup now supports Odoo versions 12.0 through 19.0
- **Documentation Updates**: Updated README, multi-version guide, and management scripts for Odoo 19.0

### ✅ Verified
- All existing tests pass on Odoo 19.0
- XML-RPC API compatibility confirmed (JSON-2 API is new but XML-RPC remains functional)
- No breaking changes required for Odoo 19.0 compatibility

## [3.6.0] - 2025-07-25

### 🚀 Major Feature Release: Multi-Version Environment

### Added
- **Multi-Version Docker Environment**: Complete Docker setup supporting Odoo versions 12.0 through 18.0 simultaneously
- **Management Scripts**: 
  - `manage-odoo.sh`: Unified script for environment management (init, start, stop, test, status, urls, clean)
  - `init-all-odoo.sh`: Automated database initialization for all Odoo versions
  - `test-all-versions.sh`: Comprehensive testing across all supported versions
- **GitHub Actions Workflows**:
  - Multi-version testing workflow with matrix strategy for all Odoo versions
  - Automated NPM publishing workflow with GitHub releases
  - Comprehensive CI/CD pipeline with service monitoring
- **Version Support Badges**: Visual badges for all supported Odoo versions (12.0-18.0) in README
- **Multi-Version Documentation**: Complete setup guide in `MULTI_VERSION_README.md`
- **Changelog**: Dedicated `CHANGELOG.md` following Keep a Changelog format

### Enhanced
- **README.md**: 
  - Added badges for all supported Odoo versions
  - New multi-version Docker environment section
  - Updated development setup instructions with quick commands
  - Expanded feature comparison table
  - Moved changelog to dedicated file
  - Added reference to Multi-Version Setup Guide
- **Docker Environment**:
  - PostgreSQL 15 shared database with individual databases per version
  - Sequential port mapping (12069, 13069, 14069, etc.)
  - Automated PostgreSQL user creation and security compliance
  - wkhtmltopdf service integration for all versions

### Changed
- **Docker Structure**: Reorganized `odoo-local/` directory structure for better maintainability
- **Script Language**: All management scripts converted to English for international compatibility
- **Database Security**: Improved PostgreSQL user management with automated creation
- **Documentation**: Moved changelog from README to dedicated CHANGELOG.md file

### Technical Details
- **Supported Odoo Versions**: 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0
- **Test Coverage**: 37 comprehensive tests per version
- **Container Architecture**: 7 Odoo containers + PostgreSQL + wkhtmltopdf
- **Port Strategy**: Base port + version number (e.g., 12069 for v12.0)
- **Database Strategy**: Individual databases (odoo12, odoo13, etc.)

### Developer Experience
- **One-Command Setup**: `./manage-odoo.sh init` initializes entire environment
- **Comprehensive Testing**: `./manage-odoo.sh test` runs tests against all versions
- **Status Monitoring**: Real-time service status and health checks
- **Documentation**: Complete setup and usage guides

## [3.5.0] - 2025-07-23

### 🔒 Major Security & Validation Release

### Added
- **Enhanced Security Validations**: Comprehensive input validation for all methods
- **Connection Timeout**: 30-second timeout for connection attempts
- **Error Sanitization**: Sanitized error messages to prevent information leakage
- **Comprehensive Test Suite**: 37 tests covering security, functionality, and edge cases
- **SQL Injection Prevention**: Parameter sanitization and validation
- **Type Checking**: Strict validation for all input parameters

### Enhanced
- **Constructor Validation**: Validates and sanitizes baseUrl, port, database, username, password
- **URL Handling**: Improved URL parsing and validation with protocol detection
- **Error Handling**: Enhanced error messages with security-conscious information disclosure
- **Performance Tests**: Added bulk operation efficiency testing
- **Concurrent Operation Safety**: Protection against race conditions

### Security Improvements
- **Input Sanitization**: All user inputs are validated and sanitized
- **Error Message Filtering**: Prevents sensitive information exposure
- **Connection Security**: Timeout protection against hanging connections
- **Parameter Validation**: Strict type and format checking
- **SQL Injection Protection**: Parameterized queries and input escaping

### Testing Enhancements
- **Security Test Suite**: Dedicated security-focused test cases
- **Performance Testing**: Bulk operation and concurrent access tests
- **Error Scenario Coverage**: Comprehensive error condition testing
- **Environment Variable Support**: Configurable test parameters
- **Integration Testing**: Real Odoo instance testing (requires Docker)

### Package Management
- **Scoped Package**: Transformed to `@renanteixeira/odoo-await`
- **Dependency Updates**: Updated mocha to v11.7.1 with security fixes
- **Vulnerability Fixes**: Resolved npm audit vulnerabilities
- **Enhanced Documentation**: Security features and migration guide

## [3.0.0] - Previous Release (Original by @vettloffah)

### Breaking Changes
- **Port Resolution**: Default port behavior changed to use protocol defaults instead of 8069
- **Port Precedence**: Updated to explicit option → URL port → protocol default (443/80)

### Maintained
- **Backward Compatibility**: All existing API methods remain unchanged
- **Promise Support**: Full async/await compatibility
- **XML-RPC Integration**: Seamless Odoo XML-RPC API integration

---

## Legacy Versions (Original Package by @vettloffah)

### [3.4.1] - Type Declarations Fix
- Fixed type declarations

### [3.4.0] - TypeScript Support
- Added type declarations from PR #34 (thanks to @bebjakub)

### [3.3.2] - Basic Auth Support
- Merged PR #30 for basic authentication support

### [3.3.1] - Security Updates
- Updated packages for vulnerability fixes (contribution by @aharter)

### [3.3.0] - Server Actions
- Added `action()` method to execute specified server action on record(s)

### [3.2.0] - URL Basic Auth
- Added support for URL basic auth (thanks to @aharter - PR #17)

### [3.1.0] - Modern Dependencies
- Replaced deprecated `querystring` package with global URL
- Removed tests that might fail on databases with existing records

### [2.4.0] - Context Support
- Added `context` option to `searchRead()` method (thanks to @tomas-padrieza)

### [2.3.0] - Logical Operators
- Added support for logical operators while searching

### [2.2.3] - Documentation
- Updated README

### [2.2.2] - Logging & Dependencies
- Removed console log on successful connection (PR #15)
- Updated dependency glob-parent
- Updated README

### [2.2.0] - Sorting Support
- Added sorting support for records returned by `searchRead()` function (thanks to @tsogoo)

---

## Version Support Matrix

| Version | Odoo 12.0 | Odoo 13.0 | Odoo 14.0 | Odoo 15.0 | Odoo 16.0 | Odoo 17.0 | Odoo 18.0 |
|---------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
| 3.6.0   | ✅        | ✅        | ✅        | ✅        | ✅        | ✅        | ✅        |
| 3.5.0   | ✅        | ✅        | ✅        | -         | -         | -         | -         |
| 3.0.0   | ✅        | ✅        | -         | -         | -         | -         | -         |

## Migration Guide

### From 3.5.0 to 3.6.0
- **New Features**: Multi-version Docker environment available
- **No Breaking Changes**: All existing code continues to work
- **Optional**: Use new management scripts for enhanced development experience

### Docker Environment Migration
```bash
# Old single-version setup
cd odoo-local/12.0
docker-compose up -d

# New multi-version setup
./manage-odoo.sh init  # Initializes all versions
./manage-odoo.sh test  # Tests all versions
```

## Contributing

When adding new features or fixes:
1. Update this CHANGELOG.md with your changes
2. Follow [Semantic Versioning](https://semver.org/) for version bumps
3. Test against all supported Odoo versions using `./manage-odoo.sh test`
4. Update documentation as needed

## Links

- [GitHub Repository](https://github.com/renanteixeira/odoo-await)
- [NPM Package](https://www.npmjs.com/package/@renanteixeira/odoo-await)
- [Multi-Version Setup Guide](./MULTI_VERSION_README.md)
- [Security Documentation](./SECURITY_IMPROVEMENTS.md)
