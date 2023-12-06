import mysql from "mysql";

var connection = mysql.createConnection({
  host: "host.docker.internal",
  user: "root", // REPLACE W YOUR USERNAME
  password: "root", // REPLACE W YOUR PASSWORD
  database: "moviesite"
});

connection.connect(function(err) {
  if (err) throw err;
});

export default connection;