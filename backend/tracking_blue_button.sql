DROP TABLE IF EXISTS tracking_blue_button;

CREATE TABLE tracking_blue_button(
  request_id TEXT,
  UUID TEXT,
  net_id TEXT,
  longitude REAL,
  latitude REAL,
  time TEXT,
  resolved INT,
  PRIMARY KEY (net_id, request_id)
);