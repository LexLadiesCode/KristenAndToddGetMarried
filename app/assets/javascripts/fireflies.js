function Firefly(id, divElement){
  var that = {};
  that.divElement = divElement;
  that.isOut = false;
  that.id = id;

  that.On = function() {
    var div = $(that.divElement);
    div.removeClass('blink');
    that.isOut = false;
    return true;
  };

  that.Off = function() {
    $(that.divElement).addClass('blink'); //make it a jQuery object before trying to use jQuery methods
    that.isOut = true;
    return true;
  };

  return that;
}

// conductor of fireflies
function FireflyGroup() {
  var that = {};
  that.flies = [];
  that.direction = '';

  that.AddFirefly = function(fly) {
    that.flies.push(fly);
    return true;
  }

  that.GetNeighbor = function(currentFlyId) {
    console.log(that.direction);
    if (currentFlyId === that.flies.length - 1) {
      that.direction = 'RTL';
      return that.flies[that.flies.length - 2]; //go ahead and return the neighbor
    } else if (currentFlyId === 0) {
      that.direction = 'LTR';
      return that.flies[1]; // go ahead and return the neighbor
    };
    if (that.direction === 'LTR') {
      // get the fly to the right
      return that.flies[currentFlyId + 1];
    } else {
      // get the fly to the left
      console.log("go left");
      return that.flies[currentFlyId - 1];
    };

    return false; // if this happens there's been an error
  };

  that.LightItUp = function(currentFly, timeOut) {
    currentFly.On();
    setTimeout( function() {
      that.LightItUp(that.GetNeighbor(currentFly.id), timeOut + 2000);
      that.ShutHerDown(currentFly, timeOut);
    }, 2000);
  };

  that.ShutHerDown = function(currentFly, timeOut) {
    setTimeout( function() {
      currentFly.Off();
    }, timeOut + 2000);
  };

  that.StartShow = function() {
    var firstFly = that.flies[0];
    firstFly.On();
    setTimeout( function() {
      that.LightItUp(firstFly, 2000);
    }, 2000);
  };

  return that;
}

var fireflies = FireflyGroup();

fireflyElements = $('.firefly'); // jQuery getting all the div with .firefly class

fireflyElements.each( function (index, value) {
  var id = "firefly"+index;
  $(value).attr("id", id);
  var newFirefly = new Firefly(index, value);
  newFirefly.Off();
  fireflies.AddFirefly(newFirefly);
});

fireflies.StartShow();
