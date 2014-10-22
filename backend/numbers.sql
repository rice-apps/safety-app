
#
# Host: localhost (MySQL 5.6.21)
# Database: wellbeing





# Dump of table important_numbers
# ------------------------------------------------------------

DROP TABLE IF EXISTS important_numbers;

CREATE TABLE important_numbers (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  name varchar(50) DEFAULT NULL,
  number varchar(10) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




