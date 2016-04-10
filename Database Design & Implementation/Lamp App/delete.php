<?php
 
 //get the data from the link that the user clicked
 $listing_id = $_GET['listing_id'];
 
 //connect to the database server
 $cxn = mysqli_connect(	"warehouse.cims.nyu.edu", 
 						"xak200", 
 						"9fdrthby", 
 						"xak200_db_hw5");
 
 //assemble the query
 //with all the variables inserted, your query should look something like:
 //DELETE FROM favorite_viking_metal_bands WHERE id=15
 $query = "DELETE FROM listing WHERE id=" . $listing_id;
 
 //DEBUGGING: print out the query with the variables inserted to make sure it looks valid
 //print("Query: " . $query);
 
 //execute the query. 
 $result = $cxn->query($query); 

 //redirect the browser to the main page
 header("Location:read.php");
 
 ?> 
