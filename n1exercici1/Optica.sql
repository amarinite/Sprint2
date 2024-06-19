DROP DATABASE IF EXISTS optica;
CREATE DATABASE optica; 
USE optica;

CREATE TABLE `supplier` (
  `supplier_id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `address_id` integer NOT NULL,
  `phone` integer NOT NULL,
  `fax` integer,
  `nif` varchar(10)
);

CREATE TABLE `address` (
  `address_id` integer PRIMARY KEY AUTO_INCREMENT,
  `street` varchar(100) NOT NULL,
  `number` integer NOT NULL,
  `floor` integer,
  `door` integer,
  `zipcode` integer NOT NULL,
  `city` varchar(45) NOT NULL,
  `country` varchar(45) NOT NULL
);

CREATE TABLE `glasses` (
  `glasses_id` integer PRIMARY KEY AUTO_INCREMENT,
  `brand` varchar(45) NOT NULL,
  `power` double NOT NULL,
  `frame_colour` varchar(45) NOT NULL,
  `glass_colour` varchar(45) NOT NULL,
  `price` double NOT NULL,
  `frame` enum("metal","paste","floating") NOT NULL,
  `supplier_id` integer NOT NULL
);

CREATE TABLE `client` (
  `client_id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `register_date` date NOT NULL,
  `referred_by_id` integer,
  `address_id` integer NOT NULL
);

CREATE TABLE `seller` (
  `seller_id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(45) NOT NULL
);

CREATE TABLE `sale` (
  `sale_id` integer PRIMARY KEY AUTO_INCREMENT,
  `sold_to_id` integer NOT NULL,
  `sold_by_id` integer NOT NULL,
  `glasses_id` integer NOT NULL
);

ALTER TABLE `supplier` ADD FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`);

ALTER TABLE `client` ADD FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`);

ALTER TABLE `glasses` ADD FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`);

ALTER TABLE `client` ADD FOREIGN KEY (`referred_by_id`) REFERENCES `client` (`client_id`);

ALTER TABLE `sale` ADD FOREIGN KEY (`sold_by_id`) REFERENCES `seller` (`seller_id`);

ALTER TABLE `sale` ADD FOREIGN KEY (`sold_to_id`) REFERENCES `client` (`client_id`);

ALTER TABLE `sale` ADD FOREIGN KEY (`glasses_id`) REFERENCES `glasses` (`glasses_id`);