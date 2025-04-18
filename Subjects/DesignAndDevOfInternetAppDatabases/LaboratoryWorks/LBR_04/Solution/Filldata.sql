--  CLIENT : 
INSERT INTO CLIENT (LOGIN, PASSWORD) VALUES 
('funnyCat', 'meow123'),
('sillyDog', 'bark456'),
('happyPenguin', 'slide789'),
('quirkyOstrich', 'runFast!'),
('cheerfulLlama', 'spitItOut!'),
('wittySquirrel', 'nutsAndBolts'),
('jollyGiraffe', 'tallTales!'),
('merryHippo', 'waterDance!'),
('playfulOtter', 'swimTime!'),
('zanyZebra', 'stripeIt!');

-- CLIENT_INFO: 
INSERT INTO CLIENT_INFO (CLIENT_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, EMAIL, PHONE_NUMBER) VALUES 
(1, 'Bobby', 'Funster', 'W.', '123 Happy St', 'bobbyfun@example.com', '1234567890'),
(2, 'Daisy', 'Wag', 'F.', '456 Silly Ave', 'daisywag@example.com', '2345678901'),
(3, 'Penny', 'Slide', 'G.', '789 Chill Blvd', 'pennyslide@example.com', '3456789012'),
(4, 'Ollie', 'Run', 'H.', '321 Speedy Ln', 'ollierun@example.com', '4567890123'),
(5, 'Lenny', 'Spit', 'I.', '654 Spit St', 'lennyspit@example.com', '5678901234'),
(6, 'Nina', 'Nutty', 'J.', '987 Nut St', 'ninanuts@example.com', '6789012345'),
(7, 'Gary', 'Tall', 'K.', '135 Tall Rd', 'garytall@example.com', '7890123456'),
(8, 'Marty', 'Water', 'L.', '246 Splash St', 'martywater@example.com', '8901234567'),
(9, 'Otto', 'Swim', 'M.', '357 Swim Ln', 'ottoswim@example.com', '9012345678'),
(10, 'Zara', 'Stripe', 'N.', '468 Stripe St', 'zarastripe@example.com', '0123456789');

-- DRIVER:
INSERT INTO DRIVER (LOGIN, PASSWORD) VALUES 
('speedyTurtle', 'slowAndSteady'),
('ninjaFrog', 'jumpHigh!'),
('crazyKoala', 'sleepyTime!'),
('sneakyFox', 'cleverMoves!'),
('jumpyKangaroo', 'bounceBounce!'),
('charmingParrot', 'talkative!'),
('joyfulPanda', 'bambooLove!'),
('quirkyRaccoon', 'trashDancer!'),
('spunkyFerret', 'playfulSpirit!'),
('dapperPenguin', 'tuxedoTime!');

-- DRIVER_INFO: ---!
INSERT INTO DRIVER_INFO (DRIVER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER, VEHICLE_INFO) VALUES 
(1, 'Terry', 'Shell', 'A.', '111 Turtle Way', '1980-01-01', 'terryshell@example.com', '123456789', '1234567890', 5),
(2, 'Freddy', 'Jump', 'B.', '222 Frog St', '1985-02-02', 'freddyjump@example.com', '234567890', '2345678901', 6),
(3, 'Kylie', 'Koala', 'C.', '333 Sleepy Ln', '1990-03-03', 'kyliek@example.com', '345678901', '3456789012', 7),
(4, 'Fiona', 'Fox', 'D.', '444 Clever Rd', '1995-04-04', 'fionafox@example.com', '456789012', '4567890123', 8),
(5, 'Kylie', 'Kangaroo', 'E.', '555 Bounce Blvd', '1982-05-05', 'kyliekangaroo@example.com', '567890123', '5678901234', 9),
(6, 'Polly', 'Parrot', 'F.', '666 Talk St', '1988-06-06', 'pollyparrot@example.com', '678901234', '6789012345', 10),
(7, 'Penny', 'Panda', 'G.', '777 Bamboo Rd', '1975-07-07', 'pennypanda@example.com', '789012345', '7890123456', 1),
(8, 'Ricky', 'Raccoon', 'H.', '888 Trash Ln', '1993-08-08', 'rickyraccoon@example.com', '890123456', '8901234567', 2),
(9, 'Felix', 'Ferret', 'I.', '999 Fun Blvd', '1987-09-09', 'felixferret@example.com', '901234567', '9012345678', 3),
(10, 'Peter', 'Penguin', 'J.', '1000 Ice St', '1992-10-10', 'peterpenguin@example.com', '012345678', '0123456789', 4);

-- CARGO:
INSERT INTO CARGO (NAME, DESCRIPTION, WEIGHT, VOLUME, CARGO_TYPE, HAZARDOUS) VALUES 
('Wacky Widgets', 'Fun and quirky widgets', 100.00, 1.00, 1, 'No'),
('Silly String', 'Endless fun string', 200.00, 3.00, 2, 'No'),
('Cheesy Chews', 'Delicious cheese snacks', 50.00, 0.50, 1, 'No'),
('Bouncy Balls', 'Fun bouncing balls', 150.00, 2.50, 3, 'Class 1'),
('Magic Potions', 'Mystical potions', 300.00, 4.00, 4, 'Class 2'),
('Giggle Juice', 'Fun drink', 500.00, 5.00, 5, 'No'),
('Rainbow Sprinkles', 'Colorful sprinkles', 120.00, 2.00, 2, 'Class 3'),
('Magic Markers', 'Colorful markers', 30.00, 0.20, 1, 'No'),
('Jelly Beans', 'Sweet jelly beans', 20.00, 0.10, 1, 'No'),
('Whimsical Whistles', 'Fun whistles', 250.00, 2.50, 3, 'No');

-- CARGO_TYPE:
INSERT INTO CARGO_TYPE (NAME, DESCRIPTION) VALUES 
('Fun Stuff', 'General fun items'),
('Bouncy Goods', 'Items that bounce'),
('Yummy Treats', 'Food items'),
('Magic Items', 'Mystical and magical'),
('Heavy Fun', 'Heavy items for fun'),
('Colorful Goods', 'Vibrant and colorful'),
('Art Supplies', 'For creative fun'),
('Party Goods', 'Items for celebrations'),
('Novelty Items', 'Unique and quirky'),
('Sweet Treats', 'Delicious goodies');

-- ORDERS: --!
INSERT INTO ORDERS (CLIENT_ID, DRIVER_ID, SERVICE_ID, STATUS, ROUTE, DELIVERY_TYPE, TOTAL_WEIGHT, TOTAL_VOLUME, DELIVERED_AT) VALUES 
(1, 1, 1, 'Pending', 1, 'Fun Express', 100.00, 1.00, NULL),
(2, 2, 2, 'In Transit', 2, 'Party Express', 200.00, 3.00, NULL),
(3, 3, 3, 'Delivered', 3, 'Happy Delivery', 150.00, 2.50, CURRENT_TIMESTAMP),
(4, 4, 4, 'Cancelled', 4, 'Silly Shipping', 300.00, 4.00, NULL),
(5, 5, 5, 'On Hold', 5, 'Joyful Delivery', 500.00, 5.00, NULL),
(6, 6, 6, 'Completed', 6, 'Cheerful Delivery', 100.00, 1.00, CURRENT_TIMESTAMP),
(7, 7, 7, 'Returned', 7, 'Happy Returns', 200.00, 3.00, NULL),
(8, 8, 8, 'Lost', 8, 'Express Delivery', 150.00, 2.50, NULL),
(9, 9, 9, 'Awaiting Pickup', 9, 'Joyful Pickup', 300.00, 4.00, NULL),
(10, 10, 10, 'Exception', 10, 'Silly Shipping', 500.00, 5.00, NULL);

-- VEHICLE: 
INSERT INTO VEHICLE (DRIVER_ID, VEHICLE_TYPE, LICENSE_PLATE, MODEL, CAPACITY, INSURANCE_EXPIRY, STATUS) VALUES 
(1, 1, 'FUN123', 'Party Bus', 1000.00, '2025-12-31', 'Available'),
(2, 2, 'HAPPY456', 'Joy Ride', 1500.00, '2025-12-31', 'In transit'),
(3, 1, 'SILLY789', 'Giggle Mobile', 2000.00, '2025-12-31', 'Available'),
(4, 2, 'LAUGH012', 'Fun Wagon', 1200.00, '2025-12-31', 'On route'),
(5, 1, 'GIGGLE345', 'Jolly Ride', 1600.00, '2025-12-31', 'Available'),
(6, 2, 'CHEER678', 'Bouncy Car', 1400.00, '2025-12-31', 'Delayed'),
(7, 1, 'SMILE901', 'Happy Van', 1900.00, '2025-12-31', 'Available'),
(8, 2, 'FUNNY234', 'Jester Truck', 1700.00, '2025-12-31', 'On platform'),
(9, 1, 'FESTIVE567', 'Party Machine', 1800.00, '2025-12-31', 'Busy'),
(10, 2, 'PARTY890', 'Fun Cruiser', 2000.00, '2025-12-31', 'Available');

-- VEHICLE_TYPE:
INSERT INTO VEHICLE_TYPE (NAME, DESCRIPTION) VALUES 
('Party Van', 'A van for all your party needs'),
('Joy Ride', 'A fun vehicle for exciting trips'),
('Giggle Bus', 'A bus that makes you laugh'),
('Bouncy Car', 'A car that brings joy'),
('Happy Truck', 'A truck filled with happiness'),
('Jolly Ride', 'A ride that makes you smile'),
('Fun Express', 'The express for fun deliveries'),
('Smiley Van', 'A van that spreads smiles'),
('Cheerful Cruiser', 'A cruiser that lifts your spirits'),
('Festival Truck', 'A truck perfect for festivals');

-- SERVICE_TYPE:
INSERT INTO SERVICE_TYPE (NAME, DESCRIPTION) VALUES 
('Fun Delivery', 'Delivery with a smile'),
('Joy Ride', 'Exciting rides with fun'),
('Party Planning', 'Planning your perfect party'),
('Giggle Service', 'Service that brings laughter'),
('Celebration Support', 'Supporting your celebrations'),
('Happy Transport', 'Transport that makes you happy'),
('Cheerful Assistance', 'Assistance with a cheerful touch'),
('Jolly Events', 'Events that spread joy'),
('Smiley Services', 'Services that put a smile on your face'),
('Fun Experiences', 'Experiences that are fun-filled');

-- SERVICES: 
INSERT INTO SERVICES (NAME, DESCRIPTION, BASE_RATE, SERVICE_TYPE_ID, CREATED_AT) VALUES 
('Happy Delivery', 'Delivering happiness', 50.00, 1, CURRENT_TIMESTAMP),
('Joyful Ride', 'An exciting ride for you', 70.00, 2, CURRENT_TIMESTAMP),
('Party Planner', 'Planning your fun events', 100.00, 3, CURRENT_TIMESTAMP),
('Giggle Service', 'Service that makes you laugh', 60.00, 4, CURRENT_TIMESTAMP),
('Celebration Transport', 'Transport for your celebrations', 80.00, 5, CURRENT_TIMESTAMP),
('Cheerful Delivery', 'Deliveries that spread cheer', 55.00, 6, CURRENT_TIMESTAMP),
('Fun Events', 'Making your events fun', 90.00, 7, CURRENT_TIMESTAMP),
('Smiley Service', 'Service that brings smiles', 75.00, 8, CURRENT_TIMESTAMP),
('Jolly Transport', 'Joyful transport services', 85.00, 9, CURRENT_TIMESTAMP),
('Fun Experience', 'Creating fun experiences for you', 95.00, 10, CURRENT_TIMESTAMP);

-- ROUTES:
INSERT INTO ROUTES (START_LOCATION, END_LOCATION, DISTANCE) VALUES 
('Joyful Park', 'Happy Avenue', 5.0),
('Party Central', 'Giggle Lane', 10.0),
('Smiley Beach', 'Fun Island', 15.0),
('Laughter City', 'Joy Road', 20.0),
('Cheerful Valley', 'Merry Hill', 8.0),
('Happy Town', 'Gigglesburg', 12.0),
('Fun Village', 'Jolly Farm', 9.0),
('Wonderland', 'Fantasy Land', 25.0),
('Joyful Gardens', 'Blissful Meadows', 14.0),
('Cheerful Heights', 'Happiness Valley', 18.0);