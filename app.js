// Generated by CoffeeScript 1.7.1
(function() {
  var graph, item, onDoubleClick, onMouseDown, onMouseMove, onMouseUp;

  onMouseDown = function(event, g, context) {
    console.log('mousedown called');
    context.initializeMouseDown(event, g, context);
    if (event.altKey || event.shiftKey) {
      return Dygraph.startZoom(event, g, context);
    } else {
      return Dygraph.startPan(event, g, context);
    }
  };

  onDoubleClick = function(event, g, context) {
    console.log('double click called');
    return g.updateOptions({
      dateWindow: null,
      valueRange: null
    });
  };

  onMouseMove = function(event, g, context) {
    console.log('move called');
    if (context.isPanning) {
      return Dygraph.movePan(event, g, context);
    } else if (context.isZooming) {
      return Dygraph.moveZoom(event, g, context);
    }
  };

  onMouseUp = function(event, g, context) {
    console.log('mouseup called');
    if (context.isPanning) {
      return Dygraph.endPan(event, g, context);
    } else if (context.isZooming) {
      return Dygraph.endZoom(event, g, context);
    }
  };

  graph = new Dygraph(document.getElementById("graph"), (function() {
    var _i, _len, _results;
    _results = [];
    for (_i = 0, _len = light_curve_data.length; _i < _len; _i++) {
      item = light_curve_data[_i];
      _results.push([item['x'], item['y']]);
    }
    return _results;
  })(), {
    labels: ["x", "y"],
    drawPoints: true,
    drawAxesAtZero: true,
    strokeWidth: 0,
    width: 1000,
    height: 400,
    interactionModel: {
      mousedown: onMouseDown,
      mousemove: onMouseMove,
      mouseup: onMouseUp,
      dblclick: onDoubleClick
    },
    showRangeSelector: true,
    rangeSelectorHeight: 30,
    rangeSelectorPlotStrokeColor: 'grey',
    rangeSelectorPlotFillColor: 'lightgrey'
  });

}).call(this);