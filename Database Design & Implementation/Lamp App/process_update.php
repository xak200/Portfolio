<?php
 
 //get the data the user entered into the form
 $listing_id = $_POST['listing_id'];
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
 //UPDATE favorite_viking_metal_bands SET band='Nordic Plague', origin='Norway', formed=1986 WHERE id=15
 $query = "UPDATE listing SET address='{$address}', price='{$price}', num_bed={$num_bed} WHERE id={$listing_id}";
 
 //execute the query. 
 $result = $cxn->query($query); 
 
 //redirect the browser to the main page
 header("Location:read.php");
 
 ?> 
