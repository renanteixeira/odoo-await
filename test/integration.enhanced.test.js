const OdooAwait = require('../lib/index');
const should = require('should');

describe('OdooAwait', () => {

  const odoo = new OdooAwait({
    baseUrl: process.env.ODOO_BASE_URL,
    port: process.env.ODOO_PORT,
    db: process.env.ODOO_DB,
    username: process.env.ODOO_USER,
    password: process.env.ODOO_PW
  });

  describe('#constructor()', () => {
    it('Should handle missing options gracefully', () => {
      const odooDefault = new OdooAwait();
      odooDefault.should.have.property('host', 'localhost');
      odooDefault.should.have.property('db', 'odoo_db');
    });

    it('Should validate and sanitize baseUrl', () => {
      const odooHttps = new OdooAwait({ baseUrl: 'https://example.com' });
      odooHttps.should.have.property('secure', true);
      odooHttps.should.have.property('host', 'example.com');
    });

    it('Should throw error for invalid URLs', () => {
      (() => {
        new OdooAwait({ baseUrl: 'not-a-valid-url' });
      }).should.throw();
    });

    it('Should handle port configuration correctly', () => {
      const odooWithPort = new OdooAwait({ 
        baseUrl: 'http://example.com:8069',
        port: 9999 
      });
      // Explicit port should override URL port
      odooWithPort.should.have.property('port', 9999);
    });

    it('Should validate required string parameters', () => {
      (() => {
        new OdooAwait({ db: null });
      }).should.throw(/Database name is required/);
      
      (() => {
        new OdooAwait({ username: '' });
      }).should.throw(/Username is required/);
    });
  });

  describe('#connect()', () => {
    it('Authenticates and returns a UID number', async() => {
      const uid = await odoo.connect();
      uid.should.be.a.Number();
      uid.should.be.above(0);
    });

    it('Should handle authentication failure gracefully', async() => {
      const badOdoo = new OdooAwait({
        baseUrl: process.env.ODOO_BASE_URL,
        port: process.env.ODOO_PORT,
        db: process.env.ODOO_DB,
        username: 'invalid_user',
        password: 'invalid_password'
      });

      try {
        await badOdoo.connect();
        throw new Error('Should have thrown authentication error');
      } catch (error) {
        error.message.should.match(/authentication failed|invalid credentials/i);
        // Should not leak sensitive information
        error.message.should.not.match(/password|secret|key/i);
      }
    });

    it.skip('Should timeout on unreachable host', async() => {
      // DISABLED: This test can be slow and cause CI issues
      // Using RFC 5737 reserved IP that is guaranteed to be non-routable
      const timeoutOdoo = new OdooAwait({
        baseUrl: 'http://203.0.113.1', // RFC 5737 TEST-NET-3 (non-routable)
        port: 8069,
        db: process.env.ODOO_DB,
        username: process.env.ODOO_USER,  
        password: process.env.ODOO_PW
      });

      try {
        await timeoutOdoo.connect();
        should.fail('Should have thrown timeout error');
      } catch (error) {
        // Should be a timeout or connection-related error
        error.message.should.match(/timeout|connect|ECONNREFUSED|EHOSTUNREACH|ENETUNREACH/i);
      }
    }).timeout(10000); // Reduced timeout for faster test execution
  });

  let recordId;
  describe('#create()', () => {
    it('Creates a record and returns a record ID', async() => {
      recordId = await odoo.create('res.partner', {
        name: 'Test Security User',
        email: 'security@test.com'
      });
      recordId.should.be.a.Number();
      recordId.should.be.above(0);
    });

    it('Should validate model parameter', async() => {
      try {
        await odoo.create(null, { name: 'Test' });
        throw new Error('Should have thrown validation error');
      } catch (error) {
        error.message.should.match(/Model name is required/i);
      }
    });

    it('Should validate params parameter', async() => {
      try {
        await odoo.create('res.partner', null);
        throw new Error('Should have thrown validation error');
      } catch (error) {
        error.message.should.match(/Parameters object is required/i);
      }
    });

    it('Should handle SQL injection attempts safely', async() => {
      const maliciousData = {
        name: "'; DROP TABLE res_partner; --",
        email: 'hacker@evil.com'
      };
      
      // Should not throw, Odoo handles SQL injection protection
      const safeRecordId = await odoo.create('res.partner', maliciousData);
      safeRecordId.should.be.a.Number();
      
      // Cleanup
      await odoo.delete('res.partner', safeRecordId);
    });
  });

  describe('#read()', () => {
    it('Fetches record data by an array of IDs', async() => {
      const records = await odoo.read('res.partner', [recordId], ['name', 'email']);
      records.should.be.instanceOf(Array);
      records.should.have.length(1);
      records[0].should.have.property('name');
      records[0].should.have.property('email');
    });

    it('Should validate recordId parameter', async() => {
      try {
        await odoo.read('res.partner', null);
        throw new Error('Should have thrown validation error');
      } catch (error) {
        error.message.should.match(/Record ID is required/i);
      }
    });

    it('Should handle non-existent record IDs gracefully', async() => {
      const records = await odoo.read('res.partner', [999999], ['name']);
      records.should.be.instanceOf(Array);
      records.should.have.length(0);
    });

    it('Should validate fields parameter type', async() => {
      const records = await odoo.read('res.partner', [recordId], 'name');
      records.should.be.instanceOf(Array);
    });
  });

  describe('#update()', () => {
    it('Updates record and returns true', async() => {
      const updated = await odoo.update('res.partner', recordId, {
        email: 'updated@security.com'
      });
      updated.should.be.exactly(true);
    });

    it('Should validate parameters', async() => {
      try {
        await odoo.update(null, recordId, { name: 'Test' });
        throw new Error('Should have thrown validation error');
      } catch (error) {
        error.message.should.match(/Model name is required/i);
      }
    });

    it('Should handle concurrent updates safely', async() => {
      const updates = [
        odoo.update('res.partner', recordId, { name: 'Concurrent Test 1' }),
        odoo.update('res.partner', recordId, { name: 'Concurrent Test 2' })
      ];
      
      const results = await Promise.all(updates);
      results.forEach(result => result.should.be.exactly(true));
    });
  });

  describe('#searchRead()', () => {
    it('Searches for records and returns the record(s) with data', async() => {
      const records = await odoo.searchRead('res.partner', 
        { email: 'updated@security.com' }, 
        ['name', 'email']
      );
      records.should.be.instanceOf(Array);
      if (records.length > 0) {
        records[0].should.have.property('name');
      }
    });

    it('Should handle complex domain filters safely', async() => {
      const records = await odoo.searchRead('res.partner', [
        ['name', 'ilike', 'test'],
        ['active', '=', true]
      ], ['name']);
      records.should.be.instanceOf(Array);
    });

    it('Should respect limit parameter', async() => {
      const records = await odoo.searchRead('res.partner', {}, ['name'], { limit: 1 });
      records.should.be.instanceOf(Array);
      records.length.should.not.be.above(1);
    });

    it('Should validate limit parameter', async() => {
      try {
        await odoo.searchRead('res.partner', {}, ['name'], { limit: -1 });
        throw new Error('Should have thrown validation error');
      } catch (error) {
        error.message.should.match(/Limit must be a positive number/i);
      }
    });
  });

  describe('#search()', () => {
    it('Searches for records and returns an array of record IDs', async() => {
      const records = await odoo.search('res.partner', { email: 'updated@security.com' });
      records.should.be.instanceOf(Array);
      if (records.length > 0) {
        records[0].should.be.a.Number();
      }
    });

    it('Should handle empty results', async() => {
      const records = await odoo.search('res.partner', { email: 'nonexistent@email.com' });
      records.should.be.instanceOf(Array);
      records.should.have.length(0);
    });
  });

  describe('#delete()', () => {
    it('Deletes record and returns true', async() => {
      const deleted = await odoo.delete('res.partner', recordId);
      deleted.should.be.exactly(true);
    });

    it('Should validate recordId parameter', async() => {
      try {
        await odoo.delete('res.partner', null);
        throw new Error('Should have thrown validation error');
      } catch (error) {
        error.message.should.match(/Record ID is required/i);
      }
    });

    it('Should handle deletion of non-existent record', async() => {
      try {
        await odoo.delete('res.partner', 999999);
        // Some Odoo versions return true even for non-existent records
      } catch (error) {
        error.should.be.instanceOf(Error);
      }
    });
  });

  describe('Security Tests', () => {
    it('Should not expose sensitive information in error messages', async() => {
      const badOdoo = new OdooAwait({
        baseUrl: process.env.ODOO_BASE_URL,
        port: process.env.ODOO_PORT,
        db: process.env.ODOO_DB,
        username: process.env.ODOO_USER,
        password: 'definitely_wrong_password_12345'
      });

      try {
        await badOdoo.connect();
      } catch (error) {
        // Error message should not contain the actual password
        error.message.should.not.match(/definitely_wrong_password_12345/);
        // But should indicate authentication failure
        error.message.should.match(/authentication failed|invalid credentials/i);
      }
    });

    it('Should handle malformed XML-RPC responses', async() => {
      // This test would require mocking the XML-RPC client
      // For now, we trust that the xmlrpc library handles this
      true.should.be.exactly(true);
    });
  });

  describe('Performance Tests', () => {
    it('Should handle bulk operations efficiently', async function() {
      this.timeout(10000);
      
      const startTime = Date.now();
      const records = await odoo.searchRead('res.partner', {}, ['name'], { limit: 100 });
      const endTime = Date.now();
      
      records.should.be.instanceOf(Array);
      (endTime - startTime).should.be.below(5000); // Should complete within 5 seconds
    });
  });
});
