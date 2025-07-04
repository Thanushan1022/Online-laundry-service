-- Online Laundry Service Database
-- Complete and Corrected Database Structure
-- Version: 4.0 - Full Website Database with 3 Admins

-- Create Database
CREATE DATABASE IF NOT EXISTS `OnlineLaundry`;
USE `OnlineLaundry`;

-- Set SQL Mode
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- Table structure for table `admin`
-- --------------------------------------------------------

CREATE TABLE `admin` (
  `AdminID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `UserName` varchar(100) NOT NULL UNIQUE,
  `Email` varchar(255) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `Role` enum('super_admin','admin','manager') DEFAULT 'admin',
  `Status` enum('active','inactive') DEFAULT 'active',
  `CreatedAt` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`AdminID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `customer`
-- --------------------------------------------------------

CREATE TABLE `customer` (
  `CustomerID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `UserName` varchar(200) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `PhoneNumber` varchar(20) NOT NULL,
  `Email` varchar(255) NOT NULL UNIQUE,
  `Address` varchar(255) NOT NULL,
  `Status` enum('active','inactive') DEFAULT 'active',
  `CreatedAt` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CustomerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `driver`
-- --------------------------------------------------------

CREATE TABLE `driver` (
  `Driver_id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(100) NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(100) NOT NULL UNIQUE,
  `address` varchar(255) NOT NULL,
  `lnumber` varchar(20) NOT NULL UNIQUE,
  `vehicle` varchar(20) NOT NULL,
  `vnumber` varchar(25) NOT NULL,
  `uname` varchar(200) NOT NULL UNIQUE,
  `pw` varchar(200) NOT NULL,
  `Status` enum('active','inactive','suspended') DEFAULT 'active',
  `CreatedAt` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Driver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `services`
-- --------------------------------------------------------

CREATE TABLE `services` (
  `ServiceID` int(11) NOT NULL AUTO_INCREMENT,
  `ServiceName` varchar(100) NOT NULL,
  `Description` text,
  `Price` decimal(10,2) NOT NULL,
  `Category` varchar(50) NOT NULL,
  `Status` enum('active','inactive') DEFAULT 'active',
  `Image` varchar(255) DEFAULT NULL,
  `CreatedAt` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `orders`
-- --------------------------------------------------------

CREATE TABLE `orders` (
  `OrderID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) NOT NULL,
  `DriverID` int(11) DEFAULT NULL,
  `OrderDate` timestamp DEFAULT CURRENT_TIMESTAMP,
  `PickupDate` date NOT NULL,
  `DeliveryDate` date NOT NULL,
  `PickupAddress` varchar(255) NOT NULL,
  `DeliveryAddress` varchar(255) NOT NULL,
  `TotalAmount` decimal(10,2) NOT NULL,
  `Status` enum('pending','confirmed','picked_up','processing','ready','out_for_delivery','delivered','cancelled') DEFAULT 'pending',
  `PaymentStatus` enum('pending','paid','failed') DEFAULT 'pending',
  `Notes` text,
  PRIMARY KEY (`OrderID`),
  FOREIGN KEY (`CustomerID`) REFERENCES `customer`(`CustomerID`) ON DELETE CASCADE,
  FOREIGN KEY (`DriverID`) REFERENCES `driver`(`Driver_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `order_items`
-- --------------------------------------------------------

CREATE TABLE `order_items` (
  `OrderItemID` int(11) NOT NULL AUTO_INCREMENT,
  `OrderID` int(11) NOT NULL,
  `ServiceID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL DEFAULT 1,
  `UnitPrice` decimal(10,2) NOT NULL,
  `TotalPrice` decimal(10,2) NOT NULL,
  `SpecialInstructions` text,
  PRIMARY KEY (`OrderItemID`),
  FOREIGN KEY (`OrderID`) REFERENCES `orders`(`OrderID`) ON DELETE CASCADE,
  FOREIGN KEY (`ServiceID`) REFERENCES `services`(`ServiceID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `payments`
-- --------------------------------------------------------

CREATE TABLE `payments` (
  `PaymentID` int(11) NOT NULL AUTO_INCREMENT,
  `OrderID` int(11) NOT NULL,
  `CustomerID` int(11) NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `PaymentMethod` enum('cash','card','paypal','bank_transfer') NOT NULL,
  `PaymentStatus` enum('pending','completed','failed','refunded') DEFAULT 'pending',
  `TransactionID` varchar(100),
  `PaymentDate` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`PaymentID`),
  FOREIGN KEY (`OrderID`) REFERENCES `orders`(`OrderID`) ON DELETE CASCADE,
  FOREIGN KEY (`CustomerID`) REFERENCES `customer`(`CustomerID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `card_payments`
-- --------------------------------------------------------

CREATE TABLE `card_payments` (
  `CardPaymentID` int(11) NOT NULL AUTO_INCREMENT,
  `PaymentID` int(11) NOT NULL,
  `CardType` varchar(50) NOT NULL,
  `CardNumber` varchar(20) NOT NULL,
  `CardHolderName` varchar(100) NOT NULL,
  `CVV` varchar(10) NOT NULL,
  `ExpirationMonth` int(2) NOT NULL,
  `ExpirationYear` int(4) NOT NULL,
  `CreatedAt` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CardPaymentID`),
  FOREIGN KEY (`PaymentID`) REFERENCES `payments`(`PaymentID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `feedback`
-- --------------------------------------------------------

CREATE TABLE `feedback` (
  `FeedbackID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) NOT NULL,
  `OrderID` int(11) DEFAULT NULL,
  `Rating` int(1) NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
  `FeedbackText` text NOT NULL,
  `FeedbackDate` timestamp DEFAULT CURRENT_TIMESTAMP,
  `Status` enum('pending','approved','rejected') DEFAULT 'pending',
  PRIMARY KEY (`FeedbackID`),
  FOREIGN KEY (`CustomerID`) REFERENCES `customer`(`CustomerID`) ON DELETE CASCADE,
  FOREIGN KEY (`OrderID`) REFERENCES `orders`(`OrderID`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `customer_support`
-- --------------------------------------------------------

CREATE TABLE `customer_support` (
  `SupportID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) DEFAULT NULL,
  `Name` varchar(100) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Phone` varchar(20) NOT NULL,
  `InquiryType` enum('existing_contract','service_issues','proposal_request','delivery_issues','other') NOT NULL,
  `Message` text NOT NULL,
  `Status` enum('open','in_progress','resolved','closed') DEFAULT 'open',
  `CreatedAt` timestamp DEFAULT CURRENT_TIMESTAMP,
  `ResolvedAt` timestamp NULL,
  PRIMARY KEY (`SupportID`),
  FOREIGN KEY (`CustomerID`) REFERENCES `customer`(`CustomerID`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `delivery_locations`
-- --------------------------------------------------------

CREATE TABLE `delivery_locations` (
  `LocationID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) NOT NULL,
  `LocationName` varchar(100) NOT NULL,
  `Address` varchar(255) NOT NULL,
  `Province` varchar(50) NOT NULL,
  `District` varchar(50) NOT NULL,
  `Area` varchar(50) NOT NULL,
  `Landmark` varchar(100),
  `IsDefault` boolean DEFAULT FALSE,
  `CreatedAt` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`LocationID`),
  FOREIGN KEY (`CustomerID`) REFERENCES `customer`(`CustomerID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `order_tracking`
-- --------------------------------------------------------

CREATE TABLE `order_tracking` (
  `TrackingID` int(11) NOT NULL AUTO_INCREMENT,
  `OrderID` int(11) NOT NULL,
  `Status` enum('order_placed','confirmed','picked_up','processing','ready','out_for_delivery','delivered','cancelled') NOT NULL,
  `Description` text,
  `UpdatedBy` enum('customer','admin','driver','system') NOT NULL,
  `UpdatedAt` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`TrackingID`),
  FOREIGN KEY (`OrderID`) REFERENCES `orders`(`OrderID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `testimonials`
-- --------------------------------------------------------

CREATE TABLE `testimonials` (
  `TestimonialID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) NOT NULL,
  `CustomerName` varchar(100) NOT NULL,
  `Rating` int(1) NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
  `TestimonialText` text NOT NULL,
  `Status` enum('pending','approved','rejected') DEFAULT 'pending',
  `CreatedAt` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`TestimonialID`),
  FOREIGN KEY (`CustomerID`) REFERENCES `customer`(`CustomerID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `faqs`
-- --------------------------------------------------------

CREATE TABLE `faqs` (
  `FAQID` int(11) NOT NULL AUTO_INCREMENT,
  `Question` text NOT NULL,
  `Answer` text NOT NULL,
  `Category` varchar(50) DEFAULT 'general',
  `Status` enum('active','inactive') DEFAULT 'active',
  `CreatedAt` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`FAQID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `notifications`
-- --------------------------------------------------------

CREATE TABLE `notifications` (
  `NotificationID` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) NOT NULL,
  `UserType` enum('customer','driver','admin') NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Message` text NOT NULL,
  `Type` enum('info','success','warning','error') DEFAULT 'info',
  `IsRead` boolean DEFAULT FALSE,
  `CreatedAt` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`NotificationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Table structure for table `app_settings`
-- --------------------------------------------------------

CREATE TABLE `app_settings` (
  `SettingID` int(11) NOT NULL AUTO_INCREMENT,
  `SettingKey` varchar(100) NOT NULL UNIQUE,
  `SettingValue` text NOT NULL,
  `Description` text,
  `UpdatedAt` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`SettingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Insert Sample Data
-- --------------------------------------------------------

-- Insert 3 Admin Users (Plain text passwords for demo - use hashed passwords in production)
INSERT INTO `admin` (`Name`, `UserName`, `Email`, `password`, `Role`, `Status`) VALUES
('Super Administrator', 'superadmin', 'superadmin@freshwash.com', 'admin123', 'super_admin', 'active'),
('System Administrator', 'admin', 'admin@freshwash.com', 'admin123', 'admin', 'active'),
('Operations Manager', 'manager', 'manager@freshwash.com', 'manager123', 'manager', 'active');

-- Insert Services
INSERT INTO `services` (`ServiceName`, `Description`, `Price`, `Category`, `Image`) VALUES
('Wash & Fold', 'Basic washing and folding service for everyday clothes. Perfect for casual wear, t-shirts, jeans, and basic garments.', 15.00, 'Basic', 'wash_fold_laundry.jpg'),
('Dry Clean', 'Professional dry cleaning service for delicate fabrics, suits, formal wear, and special garments that require special care.', 25.00, 'Premium', 'drycleaning.jpg'),
('Iron & Press', 'Professional ironing and pressing service to give your clothes a crisp, professional look.', 20.00, 'Premium', 'iron.jpg'),
('Starch & Press', 'Starching and pressing service for formal shirts and pants. Adds stiffness and professional appearance.', 22.00, 'Premium', 'ironing.jpeg'),
('Express Service', 'Same day service with additional charge. Perfect for urgent laundry needs.', 10.00, 'Express', 'washing clothes.jpg'),
('Bulk Wash', 'Large quantity washing service for families or businesses. Discounted rates for bulk orders.', 12.00, 'Bulk', 'washingMachine.jpg'),
('Curtain Cleaning', 'Professional curtain and drapery cleaning service for home and office.', 30.00, 'Premium', 'Fold.jpg'),
('Carpet Cleaning', 'Deep carpet cleaning and stain removal service.', 35.00, 'Premium', 'service.jpg'),
('Shoe Cleaning', 'Professional shoe cleaning and polishing service for all types of footwear.', 18.00, 'Premium', 'service.jpg'),
('Bedding & Linen', 'Specialized cleaning for bed sheets, pillowcases, duvets, and other bedding items.', 28.00, 'Premium', 'Fold.jpg');

-- Insert Sample Customers (Plain text passwords for demo - use hashed passwords in production)
INSERT INTO `customer` (`Name`, `UserName`, `password`, `PhoneNumber`, `Email`, `Address`) VALUES
('John Doe', 'johndoe', 'password123', '0771234567', 'john@example.com', '123 Main St, Colombo'),
('Jane Smith', 'janesmith', 'password123', '0772345678', 'jane@example.com', '456 Oak Ave, Kandy'),
('Mohamed Ihsas', 'ihsas', 'password123', '763913526', 'Mohamedihsas001@gmail.com', 'Bogwantalawa'),
('Sarah Johnson', 'sarah', 'password123', '0773456789', 'sarah@example.com', '789 Pine Rd, Galle'),
('Michael Brown', 'michael', 'password123', '0774567890', 'michael@example.com', '321 Elm St, Jaffna'),
('Emily Davis', 'emily', 'password123', '0775678901', 'emily@example.com', '654 Maple Dr, Negombo'),
('David Wilson', 'david', 'password123', '0776789012', 'david@example.com', '987 Cedar Ln, Matara'),
('Lisa Anderson', 'lisa', 'password123', '0777890123', 'lisa@example.com', '147 Birch Rd, Anuradhapura');

-- Insert Sample Drivers (Plain text passwords for demo - use hashed passwords in production)
INSERT INTO `driver` (`fname`, `gender`, `phone`, `email`, `address`, `lnumber`, `vehicle`, `vnumber`, `uname`, `pw`) VALUES
('Mohamed Ihsas', 'Male', '763913526', 'Mohamedihsas001@gmail.com', 'Bogwantalawa', 'DL123456', 'Motor Bike', 'ABC-1234', 'ihsas', 'password123'),
('Asokan Srisabeshan', 'Male', '763913526', 'sabeshan@example.com', 'Colombo', 'DL789012', 'Motor Bike', 'XYZ-5678', 'sabeshan', 'password123'),
('Kumara Silva', 'Male', '0775678901', 'kumara@example.com', 'Kandy', 'DL345678', 'Motor Bike', 'DEF-9012', 'kumara', 'password123'),
('Priya Fernando', 'Female', '0776789012', 'priya@example.com', 'Galle', 'DL901234', 'Motor Bike', 'GHI-3456', 'priya', 'password123'),
('Rajith Perera', 'Male', '0777890123', 'rajith@example.com', 'Negombo', 'DL567890', 'Motor Bike', 'JKL-7890', 'rajith', 'password123'),
('Nimal Bandara', 'Male', '0778901234', 'nimal@example.com', 'Matara', 'DL234567', 'Motor Bike', 'MNO-1234', 'nimal', 'password123');

-- Insert Sample Orders
INSERT INTO `orders` (`CustomerID`, `DriverID`, `PickupDate`, `DeliveryDate`, `PickupAddress`, `DeliveryAddress`, `TotalAmount`, `Status`, `PaymentStatus`) VALUES
(1, 1, '2024-01-15', '2024-01-17', '123 Main St, Colombo', '123 Main St, Colombo', 45.00, 'delivered', 'paid'),
(2, 2, '2024-01-16', '2024-01-18', '456 Oak Ave, Kandy', '456 Oak Ave, Kandy', 60.00, 'processing', 'paid'),
(3, 3, '2024-01-17', '2024-01-19', 'Bogwantalawa', 'Bogwantalawa', 35.00, 'ready', 'paid'),
(4, 4, '2024-01-18', '2024-01-20', '789 Pine Rd, Galle', '789 Pine Rd, Galle', 80.00, 'out_for_delivery', 'paid'),
(5, 5, '2024-01-19', '2024-01-21', '321 Elm St, Jaffna', '321 Elm St, Jaffna', 55.00, 'pending', 'pending'),
(6, 6, '2024-01-20', '2024-01-22', '654 Maple Dr, Negombo', '654 Maple Dr, Negombo', 70.00, 'confirmed', 'paid'),
(7, 1, '2024-01-21', '2024-01-23', '987 Cedar Ln, Matara', '987 Cedar Ln, Matara', 40.00, 'picked_up', 'paid'),
(8, 2, '2024-01-22', '2024-01-24', '147 Birch Rd, Anuradhapura', '147 Birch Rd, Anuradhapura', 65.00, 'pending', 'pending');

-- Insert Sample Order Items
INSERT INTO `order_items` (`OrderID`, `ServiceID`, `Quantity`, `UnitPrice`, `TotalPrice`, `SpecialInstructions`) VALUES
(1, 1, 2, 15.00, 30.00, 'Use mild detergent'),
(1, 3, 1, 20.00, 20.00, 'Medium starch'),
(2, 2, 2, 25.00, 50.00, 'Handle with care'),
(2, 4, 1, 22.00, 22.00, 'Heavy starch'),
(3, 1, 1, 15.00, 15.00, 'No fabric softener'),
(3, 3, 1, 20.00, 20.00, 'Light starch'),
(4, 2, 3, 25.00, 75.00, 'Delicate fabrics'),
(4, 5, 1, 10.00, 10.00, 'Express service'),
(5, 1, 2, 15.00, 30.00, 'Cold water wash'),
(5, 3, 1, 20.00, 20.00, 'No starch'),
(6, 1, 3, 15.00, 45.00, 'Regular wash'),
(6, 4, 1, 22.00, 22.00, 'Medium starch'),
(7, 2, 1, 25.00, 25.00, 'Delicate handling'),
(7, 3, 1, 20.00, 20.00, 'Light starch'),
(8, 1, 2, 15.00, 30.00, 'Regular wash'),
(8, 2, 1, 25.00, 25.00, 'Handle with care'),
(8, 5, 1, 10.00, 10.00, 'Express service');

-- Insert Sample Payments
INSERT INTO `payments` (`OrderID`, `CustomerID`, `Amount`, `PaymentMethod`, `PaymentStatus`, `TransactionID`) VALUES
(1, 1, 45.00, 'card', 'completed', 'TXN123456'),
(2, 2, 60.00, 'cash', 'completed', 'TXN789012'),
(3, 3, 35.00, 'paypal', 'completed', 'TXN345678'),
(4, 4, 80.00, 'card', 'completed', 'TXN901234'),
(5, 5, 55.00, 'cash', 'pending', NULL),
(6, 6, 70.00, 'card', 'completed', 'TXN567890'),
(7, 7, 40.00, 'cash', 'completed', 'TXN234567'),
(8, 8, 65.00, 'paypal', 'pending', NULL);

-- Insert Sample Feedback
INSERT INTO `feedback` (`CustomerID`, `OrderID`, `Rating`, `FeedbackText`) VALUES
(1, 1, 5, 'Excellent service! Very satisfied with the quality and delivery time. Will definitely use again.'),
(2, 2, 4, 'Good service, would recommend to others. Delivery was on time.'),
(3, 3, 5, 'Amazing quality! Clothes came back looking brand new.'),
(4, 4, 4, 'Professional service. Good communication throughout the process.'),
(6, 6, 5, 'Outstanding service! Very professional and reliable.'),
(7, 7, 4, 'Good quality work. Will use again.');

-- Insert Sample Customer Support
INSERT INTO `customer_support` (`CustomerID`, `Name`, `Email`, `Phone`, `InquiryType`, `Message`) VALUES
(1, 'John Doe', 'john@example.com', '0771234567', 'delivery_issues', 'Delivery was late by 2 hours'),
(2, 'Jane Smith', 'jane@example.com', '0772345678', 'service_issues', 'Clothes were not properly ironed'),
(3, 'Mohamed Ihsas', 'Mohamedihsas001@gmail.com', '763913526', 'proposal_request', 'Looking for bulk service for office'),
(4, 'Sarah Johnson', 'sarah@example.com', '0773456789', 'other', 'General inquiry about pricing'),
(5, 'Michael Brown', 'michael@example.com', '0774567890', 'delivery_issues', 'Driver did not call before delivery'),
(6, 'Emily Davis', 'emily@example.com', '0775678901', 'service_issues', 'Some items were missing from order');

-- Insert Sample Delivery Locations
INSERT INTO `delivery_locations` (`CustomerID`, `LocationName`, `Address`, `Province`, `District`, `Area`, `Landmark`, `IsDefault`) VALUES
(1, 'Home', '123 Main St, Colombo', 'Western', 'Colombo', 'Colombo 03', 'Near Temple', TRUE),
(2, 'Office', '456 Oak Ave, Kandy', 'Central', 'Kandy', 'Kandy City', 'Opposite Bank', TRUE),
(3, 'Home', 'Bogwantalawa', 'Central', 'Nuwara Eliya', 'Bogwantalawa', 'Near School', TRUE),
(4, 'Home', '789 Pine Rd, Galle', 'Southern', 'Galle', 'Galle City', 'Near Beach', TRUE),
(5, 'Office', '321 Elm St, Jaffna', 'Northern', 'Jaffna', 'Jaffna City', 'Near University', TRUE),
(6, 'Home', '654 Maple Dr, Negombo', 'Western', 'Gampaha', 'Negombo', 'Near Beach', TRUE),
(7, 'Home', '987 Cedar Ln, Matara', 'Southern', 'Matara', 'Matara City', 'Near Bus Stand', TRUE),
(8, 'Office', '147 Birch Rd, Anuradhapura', 'North Central', 'Anuradhapura', 'Anuradhapura City', 'Near Temple', TRUE);

-- Insert Sample Order Tracking
INSERT INTO `order_tracking` (`OrderID`, `Status`, `Description`, `UpdatedBy`) VALUES
(1, 'order_placed', 'Order has been placed successfully', 'customer'),
(1, 'confirmed', 'Order confirmed by admin', 'admin'),
(1, 'picked_up', 'Order picked up by driver', 'driver'),
(1, 'processing', 'Order is being processed', 'system'),
(1, 'ready', 'Order is ready for delivery', 'system'),
(1, 'out_for_delivery', 'Order is out for delivery', 'driver'),
(1, 'delivered', 'Order delivered successfully', 'driver'),
(2, 'order_placed', 'Order has been placed successfully', 'customer'),
(2, 'confirmed', 'Order confirmed by admin', 'admin'),
(2, 'picked_up', 'Order picked up by driver', 'driver'),
(2, 'processing', 'Order is being processed', 'system'),
(3, 'order_placed', 'Order has been placed successfully', 'customer'),
(3, 'confirmed', 'Order confirmed by admin', 'admin'),
(3, 'picked_up', 'Order picked up by driver', 'driver'),
(3, 'processing', 'Order is being processed', 'system'),
(3, 'ready', 'Order is ready for delivery', 'system'),
(4, 'order_placed', 'Order has been placed successfully', 'customer'),
(4, 'confirmed', 'Order confirmed by admin', 'admin'),
(4, 'picked_up', 'Order picked up by driver', 'driver'),
(4, 'processing', 'Order is being processed', 'system'),
(4, 'ready', 'Order is ready for delivery', 'system'),
(4, 'out_for_delivery', 'Order is out for delivery', 'driver'),
(5, 'order_placed', 'Order has been placed successfully', 'customer'),
(6, 'order_placed', 'Order has been placed successfully', 'customer'),
(6, 'confirmed', 'Order confirmed by admin', 'admin'),
(7, 'order_placed', 'Order has been placed successfully', 'customer'),
(7, 'confirmed', 'Order confirmed by admin', 'admin'),
(7, 'picked_up', 'Order picked up by driver', 'driver'),
(8, 'order_placed', 'Order has been placed successfully', 'customer');

-- Insert Sample Testimonials
INSERT INTO `testimonials` (`CustomerID`, `CustomerName`, `Rating`, `TestimonialText`, `Status`) VALUES
(1, 'John Doe', 5, 'Amazing service! The quality is outstanding and delivery is always on time. Highly recommended!', 'approved'),
(2, 'Jane Smith', 4, 'Great experience with FreshWash. Professional service and reasonable prices.', 'approved'),
(3, 'Mohamed Ihsas', 5, 'Best laundry service I have ever used. Very reliable and trustworthy.', 'approved'),
(4, 'Sarah Johnson', 5, 'Excellent customer service and high-quality results. Will definitely use again!', 'approved'),
(5, 'Michael Brown', 4, 'Good service, convenient pickup and delivery. Satisfied customer.', 'approved'),
(6, 'Emily Davis', 5, 'Outstanding quality and professional service. Highly recommend!', 'approved'),
(7, 'David Wilson', 4, 'Reliable service with good communication. Will use again.', 'approved'),
(8, 'Lisa Anderson', 5, 'Excellent service quality and timely delivery. Very satisfied!', 'approved');

-- Insert Sample FAQs
INSERT INTO `faqs` (`Question`, `Answer`, `Category`, `Status`) VALUES
('What services do you offer?', 'We offer wash & fold, dry cleaning, iron & press, starch & press, express service, bulk wash, curtain cleaning, carpet cleaning, shoe cleaning, and bedding & linen services.', 'services', 'active'),
('How long does delivery take?', 'Standard delivery takes 2-3 days. Express service is available for same-day delivery with additional charges.', 'delivery', 'active'),
('What are your payment methods?', 'We accept cash, credit/debit cards, PayPal, and bank transfers.', 'payment', 'active'),
('Do you provide pickup and delivery?', 'Yes, we provide free pickup and delivery service for all orders.', 'delivery', 'active'),
('What if I am not satisfied with the service?', 'We offer a 100% satisfaction guarantee. If you are not satisfied, we will redo your order free of charge.', 'service', 'active'),
('How do I track my order?', 'You can track your order through our website or mobile app using your order number.', 'tracking', 'active'),
('What are your operating hours?', 'We operate Monday to Saturday from 8:00 AM to 8:00 PM. Sunday from 9:00 AM to 6:00 PM.', 'general', 'active'),
('Do you handle delicate fabrics?', 'Yes, we have special care procedures for delicate fabrics and dry cleaning services.', 'services', 'active'),
('What is your cancellation policy?', 'You can cancel your order up to 2 hours before the scheduled pickup time. Late cancellations may incur a small fee.', 'general', 'active'),
('Do you offer bulk discounts?', 'Yes, we offer special discounts for bulk orders and regular customers. Contact us for more details.', 'pricing', 'active'),
('How do I report a lost item?', 'If you notice a missing item, please contact our customer support within 24 hours of delivery. We will investigate and resolve the issue.', 'service', 'active'),
('What detergents do you use?', 'We use high-quality, eco-friendly detergents that are safe for all types of fabrics and sensitive skin.', 'services', 'active');

-- Insert Sample App Settings
INSERT INTO `app_settings` (`SettingKey`, `SettingValue`, `Description`) VALUES
('company_name', 'FreshWash', 'Company name for the application'),
('company_email', 'info@freshwash.com', 'Primary company email address'),
('company_phone', '+94 11 234 5678', 'Primary company phone number'),
('company_address', '123 Business Street, Colombo 03, Sri Lanka', 'Company physical address'),
('delivery_charge', '0', 'Standard delivery charge (0 for free delivery)'),
('express_charge', '10', 'Additional charge for express service'),
('min_order_amount', '15', 'Minimum order amount'),
('max_delivery_days', '3', 'Maximum delivery days for standard service'),
('express_delivery_hours', '24', 'Express delivery in hours'),
('currency', 'LKR', 'Default currency for the application'),
('tax_rate', '15', 'Tax rate percentage'),
('maintenance_mode', 'false', 'Maintenance mode status'),
('registration_enabled', 'true', 'Allow new user registrations'),
('driver_registration_enabled', 'true', 'Allow new driver registrations');

-- Insert Sample Notifications
INSERT INTO `notifications` (`UserID`, `UserType`, `Title`, `Message`, `Type`) VALUES
(1, 'customer', 'Order Confirmed', 'Your order #1001 has been confirmed and will be picked up tomorrow.', 'success'),
(2, 'customer', 'Order Ready', 'Your order #1002 is ready and will be delivered today.', 'info'),
(3, 'customer', 'Welcome to FreshWash', 'Thank you for joining FreshWash! Enjoy our premium laundry services.', 'info'),
(1, 'driver', 'New Order Assigned', 'You have been assigned order #1001 for pickup.', 'info'),
(2, 'driver', 'Delivery Reminder', 'Please deliver order #1002 today before 6 PM.', 'warning');

-- --------------------------------------------------------
-- Create Indexes for Better Performance
-- --------------------------------------------------------

CREATE INDEX idx_customer_email ON customer(Email);
CREATE INDEX idx_customer_username ON customer(UserName);
CREATE INDEX idx_driver_email ON driver(email);
CREATE INDEX idx_driver_username ON driver(uname);
CREATE INDEX idx_orders_customer ON orders(CustomerID);
CREATE INDEX idx_orders_status ON orders(Status);
CREATE INDEX idx_orders_date ON orders(OrderDate);
CREATE INDEX idx_payments_order ON payments(OrderID);
CREATE INDEX idx_feedback_customer ON feedback(CustomerID);
CREATE INDEX idx_order_tracking_order ON order_tracking(OrderID);
CREATE INDEX idx_services_category ON services(Category);
CREATE INDEX idx_services_status ON services(Status);
CREATE INDEX idx_admin_username ON admin(UserName);
CREATE INDEX idx_admin_email ON admin(Email);
CREATE INDEX idx_notifications_user ON notifications(UserID, UserType);

-- --------------------------------------------------------
-- Create Views for Common Queries
-- --------------------------------------------------------

-- View for Order Summary
CREATE VIEW order_summary AS
SELECT 
    o.OrderID,
    c.Name AS CustomerName,
    c.Email AS CustomerEmail,
    c.PhoneNumber AS CustomerPhone,
    d.fname AS DriverName,
    o.OrderDate,
    o.PickupDate,
    o.DeliveryDate,
    o.TotalAmount,
    o.Status,
    o.PaymentStatus,
    p.PaymentMethod
FROM orders o
JOIN customer c ON o.CustomerID = c.CustomerID
LEFT JOIN driver d ON o.DriverID = d.Driver_id
LEFT JOIN payments p ON o.OrderID = p.OrderID;

-- View for Customer Dashboard
CREATE VIEW customer_dashboard AS
SELECT 
    c.CustomerID,
    c.Name,
    c.Email,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalSpent,
    AVG(f.Rating) AS AverageRating
FROM customer c
LEFT JOIN orders o ON c.CustomerID = o.CustomerID
LEFT JOIN feedback f ON c.CustomerID = f.CustomerID
GROUP BY c.CustomerID, c.Name, c.Email;

-- View for Service Analytics
CREATE VIEW service_analytics AS
SELECT 
    s.ServiceID,
    s.ServiceName,
    s.Category,
    s.Price,
    COUNT(oi.OrderItemID) AS TotalOrders,
    SUM(oi.Quantity) AS TotalQuantity,
    SUM(oi.TotalPrice) AS TotalRevenue,
    AVG(oi.UnitPrice) AS AveragePrice
FROM services s
LEFT JOIN order_items oi ON s.ServiceID = oi.ServiceID
GROUP BY s.ServiceID, s.ServiceName, s.Category, s.Price;

-- View for Driver Performance
CREATE VIEW driver_performance AS
SELECT 
    d.Driver_id,
    d.fname AS DriverName,
    d.email AS DriverEmail,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalRevenue,
    AVG(CASE WHEN o.Status = 'delivered' THEN 1 ELSE 0 END) AS DeliverySuccessRate
FROM driver d
LEFT JOIN orders o ON d.Driver_id = o.DriverID
GROUP BY d.Driver_id, d.fname, d.email;

-- View for Revenue Analytics
CREATE VIEW revenue_analytics AS
SELECT 
    DATE(o.OrderDate) AS OrderDate,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalRevenue,
    AVG(o.TotalAmount) AS AverageOrderValue,
    COUNT(CASE WHEN o.PaymentStatus = 'paid' THEN 1 END) AS PaidOrders,
    SUM(CASE WHEN o.PaymentStatus = 'paid' THEN o.TotalAmount ELSE 0 END) AS PaidRevenue
FROM orders o
GROUP BY DATE(o.OrderDate)
ORDER BY OrderDate DESC;

-- --------------------------------------------------------
-- Create Stored Procedures
-- --------------------------------------------------------

-- Procedure to get order details with items
DELIMITER //
CREATE PROCEDURE GetOrderDetails(IN order_id INT)
BEGIN
    SELECT 
        o.*,
        c.Name AS CustomerName,
        c.Email AS CustomerEmail,
        c.PhoneNumber AS CustomerPhone,
        d.fname AS DriverName,
        d.phone AS DriverPhone
    FROM orders o
    JOIN customer c ON o.CustomerID = c.CustomerID
    LEFT JOIN driver d ON o.DriverID = d.Driver_id
    WHERE o.OrderID = order_id;
    
    SELECT 
        oi.*,
        s.ServiceName,
        s.Description
    FROM order_items oi
    JOIN services s ON oi.ServiceID = s.ServiceID
    WHERE oi.OrderID = order_id;
END //
DELIMITER ;

-- Procedure to update order status
DELIMITER //
CREATE PROCEDURE UpdateOrderStatus(
    IN order_id INT,
    IN new_status VARCHAR(50),
    IN updated_by VARCHAR(20)
)
BEGIN
    UPDATE orders SET Status = new_status WHERE OrderID = order_id;
    
    INSERT INTO order_tracking (OrderID, Status, Description, UpdatedBy)
    VALUES (order_id, new_status, CONCAT('Order status updated to: ', new_status), updated_by);
END //
DELIMITER ;

-- --------------------------------------------------------
-- Create Triggers
-- --------------------------------------------------------

-- Trigger to update order total when items are added/modified
DELIMITER //
CREATE TRIGGER update_order_total
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders 
    SET TotalAmount = (
        SELECT SUM(TotalPrice) 
        FROM order_items 
        WHERE OrderID = NEW.OrderID
    )
    WHERE OrderID = NEW.OrderID;
END //
DELIMITER ;

-- Trigger to update order total when items are deleted
DELIMITER //
CREATE TRIGGER update_order_total_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders 
    SET TotalAmount = (
        SELECT COALESCE(SUM(TotalPrice), 0) 
        FROM order_items 
        WHERE OrderID = OLD.OrderID
    )
    WHERE OrderID = OLD.OrderID;
END //
DELIMITER ;

-- Trigger to create notification when order is placed
DELIMITER //
CREATE TRIGGER order_notification
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO notifications (UserID, UserType, Title, Message, Type)
    VALUES (NEW.CustomerID, 'customer', 'Order Placed', 
            CONCAT('Your order #', NEW.OrderID, ' has been placed successfully.'), 'success');
END //
DELIMITER ;

-- --------------------------------------------------------
-- Final Commit
-- --------------------------------------------------------

COMMIT;
