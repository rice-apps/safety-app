DROP TABLE IF EXISTS tracking_blue_button;
DROP TABLE IF EXISTS case_id;

CREATE TABLE tracking_blue_button(
  requestID INTEGER PRIMARY KEY,
  caseID INT,
  deviceID TEXT,
  longitude REAL,
  latitude REAL,
  date DATETIME DEFAULT CURRENT_TIMESTAMP,
  resolved INTEGER
);

CREATE TABLE case_id(
    id INT
);

--INSERT INTO tracking_blue_button(caseID, deviceID, longitude, latitude, resolved)
--  VALUES (10, "phone1", -95.40332, 29.717869, 0);

--INSERT INTO tracking_blue_button(caseID, deviceID, longitude, latitude, resolved)
--  VALUES (10, "phone1", -95.403333, 29.71786, 0);

--INSERT INTO tracking_blue_button(caseID, deviceID, longitude, latitude, resolved)
--  VALUES (10, "phone1", -95.403337, 29.717860, 0);

--INSERT INTO tracking_blue_button(caseID, deviceID, longitude, latitude, resolved)
--  VALUES (4, "phone5", -95.403330, 29.717860, 0);

--INSERT INTO tracking_blue_button(caseID, deviceID, longitude, latitude, date, resolved)
--  VALUES (11, "phone2", -95.401594, 29.716909, "2015-10-25 17:38:22", 0);
