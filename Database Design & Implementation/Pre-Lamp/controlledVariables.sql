mysql> CREATE TABLE management(management_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT, company_name VARCHAR(40) NOT NULL, phone VARCHAR(15) NOT NULL, office_address VARCHAR(40) NOT NULL, PRIMARY KEY(management_id));
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE TABLE broker(broker_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT, management_id INT(10), first_name VARCHAR(20) NOT NULL, last_name VARCHAR(20), phone VARCHAR(15) NOT NULL, office_address VARCHAR(40) NOT NULL, email VARCHAR(30) NOT NULL, PRIMARY KEY(broker_id));
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE TABLE listing(listing_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT, management_id INT(10), address VARCHAR(60) NOT NULL, zip_code INT(6) NOT NULL, neighborhood VARCHAR(30), parking BOOLEAN DEFAULT FALSE, laundry BOOLEAN DEFAULT FALSE, gym BOOLEAN DEFAULT FALSE, price INT(10) NOT NULL, sq_ft INT(6), num_bed INT(3), num_bath INT(3), PRIMARY KEY(listing_id));
Query OK, 0 rows affected (0.00 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (2, '516 E 12th St.', 10009, 'East Village', FALSE, FALSE, FALSE, 3300, 1000, 2, 1);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (4, '516 E 12th St.', 10009, 'East Village', FALSE, FALSE, FALSE, 3200, 1500, 2, 1);
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (3, '49 Essex St.', 10018, 'LES', FALSE, FALSE, FALSE, 3200, 4000, 2, 1);
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (9, '429 E 12th St.', 10003, 'East Village', FALSE, FALSE, FALSE, 3000, 10000, 2, 1);
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (4, '29 E 11t St.', 10009, 'East Village', TRUE, FALSE, FALSE, 3300, 1000, 2, 1);
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (5, '416 E 13 St.', 10009, 'East Village', FALSE, TRUE, FALSE, 3500, 1000, 2, 1);
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (3, '98 E 72 St.', 10009, 'Upper East Side', TRUE, TRUE, TRUE, 5200, 7000, 5, 3);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (8, '107 W 4th St.', 10002, 'West Village', FALSE, FALSE, TRUE, 2700, 800, 1, 1);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (4, '20 Irving Plaza', 10009, 'East Village', FALSE, FALSE, FALSE, 3500, 1000, 2, 1);
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (9, '39 Washington Sq. South', 10001, 'Greenwich Village', TRUE, FALSE, FALSE, 3300, 1000, 2, 1);
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (2, '2 E Houston St.', 10037, 'Soho', FALSE, TRUE, TRUE, 3300, 1000, 2, 1);
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (7, '32 333 3rd Ave.', 10013, 'Murray Hill', TRUE, FALSE, FALSE, 3300, 1000, 2, 1);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO listing (management_id, address, zip_code, neighborhood, parking, laundry, gym, price, sq_ft, num_bed, num_bath) VALUES (8, '82 Bleecker St.', 10003, 'Greenwich Village', FALSE, TRUE, TRUE, 3000, 2800, 3, 2);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ('Best Management Ever', '(582) 329-2389', '282 E 19th St.');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ('East Village Property Management', '(190) 291-2389', '192 E 13th St.');
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ('We Love Managing', '(291) 555-2222', '12 Prince St.');
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ('Managers R Us', '(281) 329-3901', '2819 E 3rd St.');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ('The Costco of Real Estate', '(911) 911-9111', '109 E 42nd St.');
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ('Hot as Hell Apartments', '(666) 666-6666', '666 W 66th St.');
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ('Management', '(190) 288-9832', '1901 Broadway');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ("Bob's Realty", '(123) 456-7890', '9946 Bowery Ave.');
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ("Bob's Brother's Realty", '(901) 192-7892', '18 Canal St.');
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ('Real Estate Luvrs', '(988) 918-9393', '21 Hudson St.');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ('Century 21', '(777) 300-7777', '777 W 3rd St.');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO management(company_name, phone, office_address) VALUES ('Coldwell Banker', '(290) 392-1282', '56 Christopher St.');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (5, 'Cynthia', 'Missy', '(281) 383-2888', '22 W 22nd St.', 'itshindia@gmail.com');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (8, 'Ash', 'Fang', '(221) 910-3910', '221 Forsyth St.', 'ashaf@aol.com');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (4, 'Laurel', 'Luo', '(389) 483-2900', '389 W 29 St.', 'keevyay@gmail.com');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (11, 'Kevin', 'Olivington', '(180) 289-1289', '180 W 12th St.', 'richdud3@gmail.com');
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (9, 'Andrew', 'Queen', '(234) 567-8910', '234 W 6th St.', 'stevemc@aol.com');
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (3, 'Trisha', 'Missy', '(345) 678-9101', '345 W 78th St.', 'feelin22@gmail.com');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (2, 'Jason', 'Laya', '(982) 636-3748', '982 E 37th St.', 'cakcake@gmail.com');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (10, 'Freddie', 'King', '(456) 789-1011', '456 W 45th St.', 'emailaddressmadeinelementaryschool@yahoo.com');
Query OK, 1 row affected, 1 warning (0.00 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (4, 'Francis', 'Malcolm', '(567) 891-0111', '567 E 19th St.', 'inthemiddle@comcast.com');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (7, 'Bon', 'Mercury', '(678) 910-1112', '678 Wall St.', 'bonmercury@curry.com');
Query OK, 1 row affected (0.02 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (3, 'Leo', 'Jovi', '(789) 101-1121', '165 Broadway', 'aleomost@itg.com');
Query OK, 1 row affected (0.02 sec)

mysql> INSERT INTO broker(management_id, first_name, last_name, phone, office_address, email) VALUES (7, 'Joann', 'Fabrix', '(283) 282-3829', '38 E 14th St.', 'allthefabrix@yahoo.com');
Query OK, 1 row affected (0.00 sec)