/**
*	Site-specific configuration settings for Highslide JS
*/
hs.graphicsDir = '/static/highslide/graphics/';

hs.showCredits = false;

hs.creditsPosition = 'bottom left';

hs.outlineType = 'custom';

hs.anchor = 'right'

hs.captionEval = 'this.a.title';

hs.captionOverlay.position = 'leftpanel';

hs.preserveContent = false;



// Add the slideshow controller

hs.addSlideshow({

	slideshowGroup: 'group1',

	interval: 5000,

	repeat: false,

	useControls: true,

	fixedControls: false,

	overlayOptions: {

		className: 'large-dark',

		opacity: 0.75,

		position: 'bottom center',

		offsetX: 0,

		offsetY: -10,

		hideOnMouseOut: true

	},

	thumbstrip: {

		mode: 'horizontal',

		position: 'bottom center',

		relativeTo: 'viewport'

	}



});



// gallery config object

var config1 = {

	slideshowGroup: 'group1',

	transitions: ['expand', 'crossfade']

};

