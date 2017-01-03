function theRotator() {
	//Set the opacity of all images to 0
	$('div.thumbnailView ul li').css({opacity: 0.0});

	//Get the first image and display it (gets set to full opacity)
	$('div.thumbnailView ul li:first').css({opacity: 1.0});

	//Call the rotator function to run the slideshow, 6000 = change to next image after 6 seconds
	setInterval('rotate()',6000);
}

function rotate() {
	//Get the first image
	var current = ($('div.thumbnailView ul li.show')?  $('div.thumbnailView ul li.show') : $('div.thumbnailView ul li:first'));

  if ( current.length == 0 ) current = $('div.thumbnailView ul li:first');

	//Get next image, when it reaches the end, rotate it back to the first image
	var next = ((current.next().length) ? ((current.next().hasClass('show')) ? $('div.thumbnailView ul li:first') :current.next()) : $('div.thumbnailView ul li:first'));

	//Un-comment the 3 lines below to get the images in random order
	var sibs = current.siblings();
  var rndNum = Math.floor(Math.random() * sibs.length );
  var next = $( sibs[ rndNum ] );

	//Set the fade in effect for the next image, the show class has higher z-index
	next.css({opacity: 0.0})
	.addClass('show')
	.animate({opacity: 1.0}, 1000);

	//Hide the current image
	current.animate({opacity: 0.0}, 1000)
	.removeClass('show');
};

function openMultivideo() {
	$('#mediaContainer').fadeIn(1000);
	player = jwplayer("av_player");

	if (videoLink) {
			player.setup({
				width: '900px',
				height: '506px',
				stretching: 'uniform',
				autostart: 'true',
				image: img,
				file: videoLink
		});
	}
}

$('.multiThumbs img').click(function() {
		var thumbClass= $(this).attr('class');
		$('.thumbnailView li[class!=thumbClass]').css({opacity: 0.0}).removeClass('show');
		$('.thumbnailView li.'+thumbClass).css({opacity: 1.0}).addClass('show');
});

$('.thumbnailView').click(function() {
	openMultivideo();
});

$('#launchMultivideo a').click(function() {
	openMultivideo();
});

$('.mediaContainer-mv-close').click(function() {
	$('#mediaContainer').fadeOut(1000);
	player.stop();
});

theRotator();
$('div.thumbnailView').fadeIn(1000);
$('div.thumbnailView ul li').fadeIn(1000);

$( "#resizable" ).draggable({ containment: "window", handle: "div#mediaContainerLine" });

var videoLink = $('#av_player').attr('data-video-url');
var img = $('img.thumb_001').attr('src');
