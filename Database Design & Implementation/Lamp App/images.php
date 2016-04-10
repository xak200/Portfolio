<!-- 
<?php
 
 //DEBUGGING: try to force the server to output PHP errors... some servers need this
 error_reporting(E_ALL);
 ini_set("display_errors", 1);
 
 
 //connect to the database server
 $cxn = mysqli_connect(	"warehouse.cims.nyu.edu", 
 						"xak200", 
 						"9fdrthby", 
 						"xak200_db_hw5");
 
 // //DEBUGGING: output any connection error
//  print("Connection error: " . $cxn->connect_error);
//   
//  //assemble the query
//  $query = "SELECT address, company_name, price, num_bed, num_bath, sq_ft FROM listing INNER JOIN management ON listing.management_id = management.management_id ORDER BY created ASC";
//  
 //execute the query. 
 
//$query = "SELECT * FROM listing WHERE id={$listing_id}";

//$result = $cxn->query($query); 
 
 //DEBUGGING: output any query error
 print("Query error: " . $cxn->error);
 
 ?>
 -->
 <!DOCTYPE html>
 <html>
 	<head>
 		<title>Images</title>
 		<meta charset="utf-8" />
 		<style>
			 img.delete {
				width: 10px;
				margin-left: 10px;
			 }		
 		</style>
 	</head>
 	<body>
 		<h1>Listing Images</h1>

 <!-- 
<?php while($row = mysqli_fetch_array($result)) : ?>
 -->
			<p>This beautiful Alphabet City apartment will quickly become your favorite part of New York City.
			It comes completely furnished with neatly organized, brand new furniture.</p>
				<img class='apartment' src='images/furnished.png'/>
			<p>Its tall ceilings enable you to be creative about how you choose to decorate your new space.</p>
				<img class='apartment' src='images/ceilings.png'/>
			<p>This spacious East Village apartment will give you a workout right after you get out of bed with its long hallways.</p>
				<img class='apartment' src='images/hallway.png'/>
			<p>This bathroom basically cleans itself! Compared to its dirty floors, your toilet and bathtub will always look snow.</p>
				<img class='apartment' src='images/bathroom.png'/>	 
 <!-- <?php endwhile; ?> -->
 		
 	</body>
 </html>


