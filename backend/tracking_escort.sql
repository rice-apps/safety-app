DROP TABLE IF EXISTS tracking_escort;

CREATE TABLE tracking_escort(
  requestID TEXT,
  UUID TEXT,
  netID TEXT,
  longitude REAL,
  latitude REAL,
  date TEXT,
  resolved int,
  PRIMARY KEY (netID, requestID)
);