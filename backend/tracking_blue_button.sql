DROP TABLE IF EXISTS tracking_blue_button;

CREATE TABLE tracking_blue_button(
  requestID TEXT,
  UUID TEXT,
  netID TEXT,
  longitude REAL,
  latitude REAL,
  time TEXT,
  resolved int,
  PRIMARY KEY (netID, requestID)
);

INSERT INTO tracking_blue_button(requestID, UUID, netID, longitude, latitude, time, resolved)
  VALUES ("request", "phone1", "bsl3", 29.716909, -95.401594, "19:38", 0);

INSERT INTO tracking_blue_button(requestID, UUID, netID, longitude, latitude, time, resolved)
  VALUES ("request2", "phone2", "agl5", 29.716909, -95.401594, "17:38", 0);