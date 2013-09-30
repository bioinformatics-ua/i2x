function equalheight() {    
	var maxHeight = 0;
	$('.panel').each(function(index) {       
		if($(this).height() > maxHeight)  {
			maxHeight = $(this).height();  
			//alert(maxHeight);
		}   

	}); 
	$('.panel').height(maxHeight);
}

$(window).bind("load", equalheight);
$(window).bind("resize", equalheight);