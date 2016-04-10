<?php
 
 //connect to the database server
 $cxn = mysqli_connect(	"warehouse.cims.nyu.edu", 
 						"xak200", 
 						"********", 
 						"xak200_db_hw5");
 
 //assemble the query
 $query = "SELECT company_name, office_address, phone FROM management ORDER BY management_id ASC";
 
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
 		<h1>Management Company Details</h1>
 
 		<ul>
 <?php while($row = mysqli_fetch_array($result)) : ?>
 			<li>

 			 	<?php echo $row["company_name"]; ?>
 			 	-
 			 	<?php echo $row["office_address"]; ?>
 			 	-
 			 	<?php echo $row["phone"]; ?>
 	
 			 </li>
 <?php endwhile; ?>
 		</ul>
 	</body>
 </html>


