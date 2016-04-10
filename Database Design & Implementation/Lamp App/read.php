<?php
 
 //connect to the database server
 $cxn = mysqli_connect(	"warehouse.cims.nyu.edu", 
 						"xak200", 
 						"********", 
 						"xak200_db_hw5");
 
 //assemble the query
 $query = "SELECT address, company_name, price, num_bed, num_bath, sq_ft FROM listing INNER JOIN management ON listing.management_id = management.management_id ORDER BY created ASC";
 
 //execute the query. 
 $result = $cxn->query($query); 
 
 ?>
 <!DOCTYPE html>
 <html>
 	<head>
 		<title>Read</title>
 		<meta charset="utf-8" />
 		<style>
 img.delete {
 	width: 10px;
 	margin-left: 10px;
 }		
 		</style>
 	</head>
 	<body>
 		<h1>Listings</h1>
 		<p><a href="create.php">Click here</a> to add a new listing</p>
 
 		<ul>
 <?php while($row = mysqli_fetch_array($result)) : ?>
 			<li>
 				<?php if($row = mysqli_fetch_array($result)) :?>
 					<a href="images.html?listing_id=<?php echo $row['id'];?>">
 						<?php echo $row["address"]; ?>
 					</a>
 				<?php endif; ?>
 			 	-
 			 	<a href="management.php?management_id=<?php echo $row['id'];?>">
 			 	<?php echo $row["company_name"]; ?>
 			 	</a>
 			 	-
 			 	<?php echo $row["price"]; ?>
 			 	-
 			 	<?php echo $row["num_bed"]; ?>
 			 	-
 			 	<?php echo $row["num_bath"]; ?>
 			 	-
 			 	<?php echo $row["sq_ft"]; ?>
 
 			 	<a href="edit.php?listing_id=<?php echo $row['id'];?>">
 				 	<img class='delete' src='images/edit.png' />
 				</a>
 
 			 	<a href="delete.php?listing_id=<?php echo $row['id'];?>">
 				 	<img class='delete' src='images/delete.png' />
 				</a>
 			 </li>
 <?php endwhile; ?>
 		</ul>
 	</body>
 </html>


