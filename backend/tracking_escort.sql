DROP TABLE IF EXISTS tracking_escort;

CREATE TABLE tracking_blue_button(
  requestID INTEGER PRIMARY KEY,
  caseID INTEGER,
  UUID TEXT,
  netID TEXT,
  longitude REAL,
  latitude REAL,
  date TEXT,
  resolved INTEGER
);