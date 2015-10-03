DROP TABLE IF EXISTS tracking;

CREATE TABLE tracking_blue_button(
	UUID TEXT,
	net_id TEXT,
	request_id TEXT,
  longitude REAL,
  latitude REAL,
  time TEXT,
  resolved INT
);