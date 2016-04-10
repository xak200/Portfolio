<?php
 
 
 //get the data the user entered into the form
 $address = $_POST['address'];
 $price = $_POST['price'];
 $num_bed = $_POST['num_bed'];
 
 
 //connect to the database server
 $cxn = mysqli_connect(	"warehouse.cims.nyu.edu", 
 						"xak200", 
 						"********", 
 						"xak200_db_hw5");
 

 //assemble the query
 //with all the variables inserted, your query should look something like:
 //INSERT INTO favorite_viking_metal_bands (band, origin, formed) VALUES ('Nordic Plague', 'Norway', 1986)
 $query = "INSERT into listing (address, price, num_bed) VALUES('" . $address . "','" . $price . "'," . $num_bed . ");";

 
 //execute the query. 
 $result = $cxn->query($query); 
  
 //DEBUGGING: output any query error
 print("Query error: " . $cxn->error);
 
 //redirect the browser to the main page
 header("Location:read.php");
 
 ?> 
