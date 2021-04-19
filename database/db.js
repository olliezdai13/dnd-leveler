const mysql2 = require('mysql2/promise');

async function query(sql, params) {
  const connection = await mysql2.createConnection({
    host: 'localhost',
    user: process.argv[2],
    password: process.argv[3],
    database: 'ddcharactermanager'
  });
  const [results, ] = await connection.execute(sql, params).catch(err => { console.error(err); });

  await connection.end().catch(err => { console.error(err); });

  return results;
}

module.exports = {
  query
}