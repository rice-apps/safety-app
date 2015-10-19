DROP TABLE IF EXISTS tracking_escort;

CREATE TABLE tracking_escort(
  requestID TEXT,
  UUID TEXT,
  netID TEXT,
  longitude REAL,
  latitude REAL,
  time TEXT,
  resolved BOOLEAN,
  PRIMARY KEY (net_id, request_id)
);