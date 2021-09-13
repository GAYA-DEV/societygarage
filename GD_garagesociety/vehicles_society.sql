CREATE TABLE IF NOT EXISTS `vehicles_society` (
  `id` int(55) NOT NULL AUTO_INCREMENT,
  `Label` varchar(255) NOT NULL,
  `model` varchar(55) NOT NULL,
  `plate` varchar(55) NOT NULL,
  `jobname` varchar(55) NOT NULL,
  `Tunning` varchar(12250) NOT NULL DEFAULT '[]',
  `isStored` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4;