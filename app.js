// Generated by CoffeeScript 1.7.1
(function() {
  var annotations, graph, item, onDoubleClick, onMouseDown, onMouseMove, onMouseUp;

  annotations = [];

  window.annotations = annotations;

  onMouseDown = function(event, g, context) {
    context.initializeMouseDown(event, g, context);
    console.log(context.dragStartX, context.dragStartY);
    if (event.altKey || event.shiftKey) {
      return Dygraph.startZoom(event, g, context);
    } else {
      return Dygraph.startPan(event, g, context);
    }
  };

  onDoubleClick = function(event, g, context) {
    return g.updateOptions({
      dateWindow: null,
      valueRange: null
    });
  };

  onMouseMove = function(event, g, context) {
    if (context.isPanning) {
      return Dygraph.movePan(event, g, context);
    } else if (context.isZooming) {
      return Dygraph.moveZoom(event, g, context);
    }
  };

  onMouseUp = function(event, g, context) {
    var a, bottom_left, coordinates, i, left, right, top_right, _i, _len;
    bottom_left = g.toDomCoords(g.toDataXCoord(context.dragStartX), 0);
    top_right = g.toDomCoords(g.toDataXCoord(context.dragEndX), 1);
    left = bottom_left[0];
    right = top_right[0];
    console.log("event", event, "g", g, "context", context);
    g.canvas_ctx_.fillStyle = "rgba(255, 255, 102, 0.6)";
    g.canvas_ctx_.fillRect(left, g.layout_.area_.y, right - left, g.layout_.area_.h);
    annotations.push({
      "x": left,
      "y": g.layout_.area_.y,
      "width": right - left,
      "height": g.layout_.area_.h
    });
    for (i = _i = 0, _len = annotations.length; _i < _len; i = ++_i) {
      a = annotations[i];
      g.canvas_ctx_.fillRect(a.x, a.y, a.width, a.height);
      coordinates = "" + (g.toDataXCoord(a.x)) + ", " + (g.toDataXCoord(a.x + a.width)) + "</br>";
      if (i === annotations.length - 1) {
        document.getElementById('annotations').innerHTML += coordinates;
      }
    }
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
    drawXGrid: true,
    drawYGrid: false,
    drawAxesAtZero: true,
    strokeWidth: 0,
    width: 1000,
    height: 400,
    isZoomedIgnoreProgrammaticZoom: true,
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
