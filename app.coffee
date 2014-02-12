# var light_curve_data from data.js

# hold shift and click-drag to zoom
# double click to reset

class Shape
  constructor: (x, y, w, h, fill) ->
    @x = x ? 0
    @y = y ? 0
    @w = w ? 1
    @h = h ? 1
    @fill = fill ? "rgba(255, 255, 0, .6)"

  draw: (ctx, g) ->
    # .fillRect(x,y,width,height)

    ctx.fillStyle = @fill
    width = g.xAxisRange()[1]
    scale = g.toDomXCoord(g.xAxisRange()[1])
    console.log "Drawing..."
    console.log "width", width
    console.log "scale", scale

    ctx.fillRect((@x/width * 35), @y, (@w/width * 35), @h) #this '35' needs to be the x-axis max to scale right...

class CanvasState
  constructor: (@graph) ->
    @ctx = graph.canvas_ctx_
    @canvas = graph.canvas
    @annotations = []

  addAnnotation: (annotation) ->
    @annotations.push annotation

  redrawMarks: -> shape.draw(@ctx, @graph) for shape in @annotations

onMouseDown = (event, g, context) ->
  context.initializeMouseDown(event, g, context)
  # console.log "event", event, "g", g, "context", context 
  # console.log context.dragStartX, context.dragStartY
  # console.log canvasState

onDoubleClick = (event, g, context) ->
  g.updateOptions
    dateWindow: null
    valueRange: null

onMouseMove = (event, g, context) ->
  # console.log "event", event, "g", g, "context", context 

onMouseUp = (event, g, context) ->
  left = context.dragStartX
  right = event.layerX

  console.log "left", left, "right", right

  shape = new Shape(left, g.layout_.area_.y, right - left, g.layout_.area_.h)
  shape.draw(g.canvas_ctx_, g)

  # annotation = {"x": left, "y": g.layout_.area_.y, "width": right - left, "height": g.layout_.area_.h}
  canvasState.addAnnotation(shape)

  #append to #annotations for viewing
  for a, i in canvasState.annotations
    coordinates = "#{g.toDataXCoord a.x}, #{g.toDataXCoord(a.x + a.w)}</br>"
    document.getElementById('annotations').innerHTML += coordinates if i is canvasState.annotations.length-1

graph = new Dygraph document.getElementById("graph"),
  for item in light_curve_data
    [item['x'], item['y']]

  drawPoints: true
  drawXGrid: true
  drawYGrid: false
  drawAxesAtZero: true
  strokeWidth: 0 # change to something like .1 to add lines between points
  color: "orange"
  width: 1000
  height: 400
  isZoomedIgnoreProgrammaticZoom: true
  showLabelsOnHighlight: false
  # drawHighlightPointCallback: "false"# remove hover dot
  interactionModel:
    mousedown: onMouseDown
    mousemove: onMouseMove
    mouseup: onMouseUp
    dblclick: onDoubleClick
  showRangeSelector: true
  rangeSelectorHeight: 30
  rangeSelectorPlotStrokeColor: 'grey'
  rangeSelectorPlotFillColor: 'lightgrey'
  zoomCallback: ->
    canvasState.redrawMarks()
  underlayCallback: (canvas, area, g) ->
    console.log "canvas", canvas, "Area", area, "g", g
    bottom_left = g.toDomCoords(0, -20);
    top_right = g.toDomCoords(area.w, +20);
    left = bottom_left[0];
    right = top_right[0];

    canvas.fillStyle = "#000";
    canvas.fillRect(left, area.y, right - left, area.h);

canvasState = new CanvasState(graph)
window.canvasState = canvasState
