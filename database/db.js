const mysql2 = require('mysql2/promise');

async function query(sql, params) {
  const connection = await mysql2.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'ddcharactermanager'
  });
  const [results, ] = await connection.execute(sql, params);

  return results;
}

module.exports = {
  query
}