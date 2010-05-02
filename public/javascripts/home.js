function VideoCarousel (container, videoCount, carWidth, carHeight, loadUrl) {
    var carousel;
    
    function init(){
  	    var carouselState = YAHOO.util.History.getBookmarkedState("carouselState");
		    var initialCarouselState = carouselState || "0";
			
			YAHOO.util.History.register("carouselState", initialCarouselState, function (state) {
				setCarouselFirstVisible(parseInt(state));
		    });
			
			YAHOO.util.History.onReady(function () {
		        var currentState = YAHOO.util.History.getCurrentState("carouselState");
				YAHOO.log("Init carousel with state: " + currentState);				
		        initCarousel(parseInt(currentState));
		    });
			
		    // Initialize the browser history management library.
		    try {
		        YAHOO.util.History.initialize("yui-history-field", "yui-history-iframe");
		    } catch (e) {
		        YAHOO.log("Unable to init carousel history: " + e);
		        initCarousel(0);
		    }  
    }
    YAHOO.util.Event.addListener(window, "load", init);
    
		function initCarousel(firstVisible) {
		    carousel = new YAHOO.widget.Carousel(container, {
		        animation: { speed: 0.5, effect: YAHOO.util.Easing.easeOut },
		        numVisible: [carWidth,carHeight],
				numItems: videoCount
		    });
		
			carousel.on("loadItems", loadCarouselItems);
			carousel.on("pageChange", recordCarouselHistory);
		  carousel.render();
			carousel.show();
			setCarouselFirstVisible(firstVisible);   
			YAHOO.util.Dom.removeClass(container, "hiddenDiv");			
		}
		
		function loadCarouselItems(o) {
			var offset = 0;
			var pageSize = carWidth*carHeight;
	        if(o){
	            YAHOO.log('Num: ' + o.num + " First: " + o.first + " Last: " + o.last);   
	            offset = o.first;
				pageSize = o.num;
	        }

			new Ajax.Request(loadUrl, { 
				method:'get', 
				parameters: {'offset': offset, 'page_size': pageSize},
				evalJS:'force' 
			});		
		}
	
		function addCarouselItem(item){
			carousel.addItem(item);
		}
		this.addCarouselItem = addCarouselItem;
		
		function recordCarouselHistory(e){
	        var newState = carousel.get('firstVisible');
	        try {
	            var currentState = YAHOO.util.History.getCurrentState("carouselState");
				//YAHOO.log("Carousel new: " + newState + " current: " + currentState);
	            if (newState != currentState) {
	                YAHOO.util.History.navigate("carouselState", "" + newState);
	            }
	        } catch (e) {
	            YAHOO.log("Error recording carousel history: " + e);
	        }			
		}
		
		//Sets the first visible without any animiation
		function setCarouselFirstVisible(state){
			var animation = carousel.get('animation');
			carousel.set('animation', {speed: 0, effect: null});
			carousel.set("firstVisible", state);
			carousel.set('animation', animation);
		}    
    
}