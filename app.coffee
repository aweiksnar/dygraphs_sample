# var light_curve_data from data.js

# hold shift and click-drag to zoom
# double click to reset

annotations = []
window.annotations = annotations

onMouseDown = (event, g, context) ->
  context.initializeMouseDown(event, g, context)
  # console.log "event", event, "g", g, "context", context 

  console.log context.dragStartX, context.dragStartY
  if (event.altKey || event.shiftKey)
    Dygraph.startZoom(event, g, context)
  else
    Dygraph.startPan(event, g, context)

onDoubleClick = (event, g, context) ->
  g.updateOptions
    dateWindow: null
    valueRange: null

onMouseMove = (event, g, context) ->
  if (context.isPanning)
    Dygraph.movePan(event, g, context)
  else if (context.isZooming)
    Dygraph.moveZoom(event, g, context)

onMouseUp = (event, g, context) ->
  bottom_left = g.toDomCoords(g.toDataXCoord(context.dragStartX), 0)
  top_right = g.toDomCoords(g.toDataXCoord(context.dragEndX), 1)

  left = bottom_left[0]
  right = top_right[0]

  console.log "event", event, "g", g, "context", context 

  g.canvas_ctx_.fillStyle = "rgba(255, 255, 102, 0.6)"
  g.canvas_ctx_.fillRect(left, g.layout_.area_.y, right - left, g.layout_.area_.h)
  annotations.push {"x": left, "y": g.layout_.area_.y, "width": right - left, "height": g.layout_.area_.h}

  for a, i in annotations
    g.canvas_ctx_.fillRect(a.x, a.y, a.width, a.height)

    # x axis coordinates, remove 'g.toDataXCoord' for pixels
    coordinates = "#{g.toDataXCoord a.x}, #{g.toDataXCoord(a.x + a.width)}</br>"
    document.getElementById('annotations').innerHTML += coordinates if i is annotations.length-1

  if (context.isPanning)
    Dygraph.endPan(event, g, context)
  else if (context.isZooming)
    Dygraph.endZoom(event, g, context)

graph = new Dygraph document.getElementById("graph"),
  for item in light_curve_data
    [item['x'], item['y']]
  labels: ["x", "y"]
  drawPoints: true
  drawXGrid: true
  drawYGrid: false
  drawAxesAtZero: true
  strokeWidth: 0 # change to something like .1 to add lines between points
  width: 1000
  height: 400
  isZoomedIgnoreProgrammaticZoom: true
  interactionModel:
    mousedown: onMouseDown
    mousemove: onMouseMove
    mouseup: onMouseUp
    dblclick: onDoubleClick
  showRangeSelector: true
  rangeSelectorHeight: 30
  rangeSelectorPlotStrokeColor: 'grey'
  rangeSelectorPlotFillColor: 'lightgrey'
