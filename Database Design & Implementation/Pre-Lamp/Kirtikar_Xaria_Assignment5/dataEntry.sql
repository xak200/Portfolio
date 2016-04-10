mysql> CREATE TABLE users (user_email VARCHAR(30) NOT NULL, phone VARCHAR(15) NOT NULL, first_name VARCHAR(20) NOT NULL, last_name VARCHAR(20));
Query OK, 0 rows affected (0.03 sec)

mysql> CREATE TABLE user_interest(user_interest_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT, user_email VARCHAR(30) NOT NULL, listing_id INT(10), PRIMARY KEY(user_id));
Query OK, 0 rows affected (0.01 sec)