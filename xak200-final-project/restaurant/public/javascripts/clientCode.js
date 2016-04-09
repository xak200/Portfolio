$(function() {
	$('#slides').slidesjs({
		// width: 940,
		//height: 528
		width: 600,
		height: 400
	});
});


function validateForm() {
	var x = document.forms["reviewForm"]["review"].value;
	if (x == null || x == "") {
		alert("Review must be filled out");
		return false;
	}
}

$(':radio').change(
  function(){
    $('.choice').text( this.value + ' stars' );
  } 
)
