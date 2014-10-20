
#
# Host: localhost (MySQL 5.6.21)
# Database: wellbeing





# Dump of table important_numbers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `important_numbers`;

CREATE TABLE `important_numbers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `number` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS `trackfriend`;

CREATE TABLE `trackfriend` (
  `first name` varchar(256) DEFAULT NULL,
  `last name` varchar(256) DEFAULT NULL,
  `longtitude` int(11) DEFAULT NULL,
  `altitude` int(11) DEFAULT NULL,
  `iPhone id` int(11) NOT NULL,
  PRIMARY KEY (`iPhone id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



