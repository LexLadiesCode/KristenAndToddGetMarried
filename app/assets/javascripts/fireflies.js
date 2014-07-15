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
  that.direction = 'LTR';

  that.AddFirefly = function(fly) {
    that.flies.push(fly);
    return true;
  }

  that.GetNeighbor = function(currentFly) {
    if (currentFly.id === that.flies.length) {
      that.direction = 'RTL';
      return that.flies[that.flies.length - 1]; //go ahead and return the neighbor
    } else if (currentFly.id === 0) {
      that.direction = 'LTR';
      return that.flies[1]; // go ahead and return the neighbor
    };
    if (that.direction === 'LTR') {
      // get the fly to the right
      return that.flies[currentFly.id + 1];
    } else {
      // get the fly to the left
      return that.flies[currentFly.id - 1];
    };

    return false; // if this happens there's been an error
  };

  that.StartShow = function() {
    console.log("Go!");
    var firstFly = that.flies[0];
    firstFly.On();
  };

  return that;
}

var fireflies = FireflyGroup();

fireflyElements = $('.firefly'); // jQuery getting all the div with .firefly class

fireflyElements.each( function (index, value) {
    var id = "firefly"+index;
    $(value).attr("id", id);
    var newFirefly = new Firefly(id, value);
    newFirefly.Off();
    fireflies.AddFirefly(newFirefly);
});

fireflies.StartShow();

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}
function addBlink(fly, index) {
  $(fly).addClass('blink');
  console.log("blink");
  if (index <= fireflies.length){
    sleep(1000);
    addBlink(fireflies[index++],index++);
    console.log("add next");
  }
}


function removeBlink(fly){
  fly.removeClass('blink');
}
