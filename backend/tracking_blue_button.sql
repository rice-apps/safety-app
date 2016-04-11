DROP TABLE IF EXISTS tracking_blue_button;

CREATE TABLE tracking_blue_button(
  requestID INTEGER PRIMARY KEY,
  caseID TEXT,
  deviceID TEXT,
  longitude REAL,
  latitude REAL,
  date TEXT,
  resolved INTEGER
);


--INSERT INTO tracking_blue_button(caseID, deviceID, longitude, latitude, date, resolved)
--  VALUES (10, "phone1", -95.403333, 29.717860, "2015-10-25 19:38:50", 0);

--INSERT INTO tracking_blue_button(caseID, deviceID, longitude, latitude, date, resolved)
--  VALUES (11, "phone2", 29.716909, -95.401594, "2015-10-25 17:38:22", 0);
