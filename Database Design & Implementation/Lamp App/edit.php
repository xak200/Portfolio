<?php
 
 //get the data from the URL
 $listingId = $_GET['listing_id'];
 
 //connect to the database server
 $cxn = mysqli_connect(	"warehouse.cims.nyu.edu", 
 						"xak200", 
 						"9fdrthby", 
 						"xak200_db_hw5");
  
 //assemble the query
 //with all the variables inserted, your query should look something like:
 //SELECT * FROM favorite_viking_metal_bands WHERE id=15
 $query = "SELECT * FROM listing WHERE id={$listingId}";
 
 //execute the query. 
 $result = $cxn->query($query); 
 
 //get the one row from the result set
 $row = mysqli_fetch_array($result);
 
 ?>
 <!DOCTYPE html>
 <html>
 	<head>
 		<title>Edit</title>
 		<meta charset="utf-8" />
 	</head>
 	<body>
 		<h1>Edit a row</h1>
 
 		<form method="POST" action="process_update.php">
 			<input type="hidden" name="listing_id" value="<?php echo $row['id']; ?>" />
 			
 			<label>address: </label>
 			<input name="address" type="text" value="<?php echo $row['address']; ?>" />
 			<br />
 
 			<label>price: </label>
 			<input name="price" type="text" value="<?php echo $row['price']; ?>"  />
 			<br />
 
 			<label>number of bedrooms: </label>
 			<input name="num_bed" type="text" value="<?php echo $row['num_bed']; ?>"  />
 			<br />
 
 			<input type="submit" value="Save" />
 
 		</form>
 	</body>
 </html>
