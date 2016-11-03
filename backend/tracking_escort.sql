DROP TABLE IF EXISTS tracking_escort;

CREATE TABLE tracking_escort(
  requestID INTEGER PRIMARY KEY,
  caseID TEXT,
  deviceID TEXT,
  longitude REAL,
  latitude REAL,
  date DATETIME DEFAULT CURRENT_TIMESTAMP,
  resolved INTEGER
);