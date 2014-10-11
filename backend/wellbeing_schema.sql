
# Host: localhost (MySQL 5.6.21)
# Database: wellbeing



DROP TABLE IF EXISTS `important_numbers`;

CREATE TABLE `important_numbers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `number` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

