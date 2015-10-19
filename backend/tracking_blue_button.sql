DROP TABLE IF EXISTS tracking_blue_button;

CREATE TABLE tracking_blue_button(
  requestID TEXT,
  UUID TEXT,
  netID TEXT,
  longitude REAL,
  latitude REAL,
  time TEXT,
  resolved BOOLEAN,
  PRIMARY KEY (net_id, request_id)
);