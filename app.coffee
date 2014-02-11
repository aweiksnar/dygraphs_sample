# var light_curve_data from data.js

# hold shift and click-drag to zoom
# double click to reset

onMouseDown = (event, g, context) ->
  console.log 'mousedown called'
  context.initializeMouseDown(event, g, context);
  if (event.altKey || event.shiftKey)
    Dygraph.startZoom(event, g, context)
  else
    Dygraph.startPan(event, g, context)

onDoubleClick = (event, g, context) ->
  console.log 'double click called'
  g.updateOptions
    dateWindow: null
    valueRange: null

onMouseMove = (event, g, context) ->
  console.log 'move called'
  if (context.isPanning)
    Dygraph.movePan(event, g, context)
  else if (context.isZooming)
    Dygraph.moveZoom(event, g, context)

onMouseUp = (event, g, context) ->
  console.log 'mouseup called'
  if (context.isPanning)
    Dygraph.endPan(event, g, context)
  else if (context.isZooming)
    Dygraph.endZoom(event, g, context)

graph = new Dygraph document.getElementById("graph"),
  for item in light_curve_data
    [item['x'], item['y']]

  labels: ["x", "y"]
  drawPoints: true
  drawAxesAtZero: true
  strokeWidth: 0 # change to something like .1 to add lines between points
  width: 1000
  height: 400
  interactionModel:
    mousedown: onMouseDown
    mousemove: onMouseMove
    mouseup: onMouseUp
    dblclick: onDoubleClick
  showRangeSelector: true
  rangeSelectorHeight: 30
  rangeSelectorPlotStrokeColor: 'grey'
  rangeSelectorPlotFillColor: 'lightgrey'
