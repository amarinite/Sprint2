DROP DATABASE IF EXISTS pizzeria;
CREATE DATABASE pizzeria;
USE pizzeria;

CREATE TABLE `state` (
  `state_id` integer PRIMARY KEY AUTO_INCREMENT,
  `state_name` varchar(45) NOT NULL
);

CREATE TABLE `city` (
  `city_id` integer PRIMARY KEY AUTO_INCREMENT,
  `city_name` varchar(45) NOT NULL,
  `state_id` integer NOT NULL
);

CREATE TABLE `client` (
  `client_id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `surname` varchar(45) NOT NULL,
  `address` varchar(100) NOT NULL,
  `phone` varchar(45) NOT NULL,
  `zipcode` integer NOT NULL,
  `city_id` integer NOT NULL,
  `state_id` integer NOT NULL
);

CREATE TABLE `shop` (
  `shop_id` integer PRIMARY KEY AUTO_INCREMENT,
  `address` varchar(45) NOT NULL,
  `zipcode` integer NOT NULL,
  `city_id` integer NOT NULL,
  `state_id` integer NOT NULL
);

CREATE TABLE `employee` (
  `employee_id` integer PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `surname` varchar(45) NOT NULL,
  `nif` varchar(10) NOT NULL,
  `phone` integer NOT NULL,
  `job` enum("kitchen","delivery") NOT NULL,
  `shop_id` integer NOT NULL
);

CREATE TABLE `order_item` (
  `ord_item_id` integer PRIMARY KEY AUTO_INCREMENT,
  `product_id` integer NOT NULL,
  `order_id` integer NOT NULL
);

CREATE TABLE `order` (
  `order_id` integer PRIMARY KEY AUTO_INCREMENT,
  `order_date` datetime NOT NULL,
  `total_price` integer NOT NULL,
  `is_delivery` bool NOT NULL,
  `client_id` integer NOT NULL,
  `employee_id` integer NOT NULL
);

CREATE TABLE `product` (
  `product_id` integer PRIMARY KEY AUTO_INCREMENT,
  `product_name` varchar(45) NOT NULL,
  `description` varchar(200) NOT NULL,
  `image` varchar(100) NOT NULL,
  `price` double NOT NULL,
  `type` enum("pizza","burger","drink") NOT NULL,
  `order_id` integer NOT NULL
);

CREATE TABLE `pizza` (
  `pizza_id` integer PRIMARY KEY AUTO_INCREMENT,
  `category_id` integer NOT NULL,
  `product_id` integer NOT NULL
);

CREATE TABLE `pizza_category` (
  `pizza_ctg_id` integer PRIMARY KEY AUTO_INCREMENT,
  `category_name` varchar(45) NOT NULL
);

ALTER TABLE `city` ADD FOREIGN KEY (`state_id`) REFERENCES `state` (`state_id`);

ALTER TABLE `shop` ADD FOREIGN KEY (`state_id`) REFERENCES `state` (`state_id`);

ALTER TABLE `client` ADD FOREIGN KEY (`state_id`) REFERENCES `state` (`state_id`);

ALTER TABLE `order_item` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);

ALTER TABLE `order_item` ADD FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`);

ALTER TABLE `order` ADD FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`);

ALTER TABLE `order` ADD FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`);

ALTER TABLE `employee` ADD FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`);

ALTER TABLE `pizza` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);

ALTER TABLE `pizza` ADD FOREIGN KEY (`category_id`) REFERENCES `pizza_category` (`pizza_ctg_id`);

ALTER TABLE `client` ADD FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`);

ALTER TABLE `shop` ADD FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`);

DELIMITER //
CREATE TRIGGER before_insert_pizza
BEFORE INSERT ON `pizza`
FOR EACH ROW
BEGIN
  DECLARE product_type ENUM('pizza', 'burger', 'drink');
  SELECT `type` INTO product_type FROM `product` WHERE `product_id` = NEW.`product_id`;
  IF product_type != 'pizza' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'product_id should be type "pizza"';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_insert_order
BEFORE INSERT ON `order`
FOR EACH ROW
BEGIN
  DECLARE emp_job ENUM('kitchen', 'delivery');

  SELECT `job` INTO emp_job FROM `employee` WHERE `employee_id` = NEW.`employee_id`;

  IF NEW.is_delivery = TRUE AND emp_job != 'delivery' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Delivery orders must be assigned to delivery employees';
  END IF;
END;
//