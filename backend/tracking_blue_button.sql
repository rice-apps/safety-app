DROP TABLE IF EXISTS tracking_blue_button;

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

INSERT INTO tracking_blue_button(requestID, caseID, UUID, netID, longitude, latitude, date, resolved)
  VALUES (1, 10, "phone1", "bsl3", 29.716909, -95.401594, "2015-10-25 19:38:50", 0);

INSERT INTO tracking_blue_button(caseID, UUID, netID, longitude, latitude, date, resolved)
  VALUES (11, "phone2", "agl5", 29.716909, -95.401594, "2015-10-25 17:38:22", 0);