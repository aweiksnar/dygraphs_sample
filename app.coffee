# var light_curve_data from data.js

class Shape
  constructor: (start, bottomHeight, finish, topHeight, fill) ->
    @start = Math.min(start, finish) ? 0
    @bottomHeight = bottomHeight ? 0
    @finish = Math.max(start, finish) ? 1
    @topHeight = topHeight ? 1
    @fill = fill ? "rgba(255, 255, 0, .6)"
    @width = Math.abs @start - @finish #length of mark

  draw: (ctx, g) ->
    ctx.fillStyle = @fill
    width = g.xAxisRange()[1]
    scale = g.toDomXCoord(g.xAxisRange()[1])

    #fillRect(x,y,width,height)
    ctx.fillRect (g.toDomXCoord Math.min(@start, @finish)), @bottomHeight, Math.abs(g.toDomXCoord(@start) - g.toDomXCoord(@finish)), @topHeight

class CanvasState
  constructor: (@graph) ->
    @ctx = graph.hidden_ctx_
    @canvas = graph.canvas
    @annotations = []

  addAnnotation: (annotation) -> @annotations.push annotation

  redrawMarks: -> shape.draw(@ctx, @graph) for shape in @annotations

Events = 
  constructor: -> @zoomed = false 
  onMouseDown: (event, g, context) ->
    context.initializeMouseDown(event, g, context)

  onDoubleClick: (event, g, context) ->
    @zoomed = !@zoomed
    if @zoomed
      [minX, maxX] = g.xAxisExtremes()
    else
      minX = g.toDataXCoord event.layerX
      maxX = minX + g.xAxisExtremes()[1] / 5 #zoom scale
    g.updateOptions
      dateWindow: [minX, maxX]
      valueRange: null

  onMouseMove: (event, g, context) ->
    # console.log "event", event, "g", g, "context", context 

  onMouseUp: (event, g, context) ->
    start = g.toDataXCoord context.dragStartX # actual x axis value of drag begin
    finish = g.toDataXCoord event.layerX #actual x axis value of drag end
    return if start <= 0 or finish <= 0 or start is finish#prevent -neg values and drags from rangs slider to graph

    shape = new Shape(start, g.layout_.area_.y, finish, g.layout_.area_.h)
    shape.draw(g.hidden_ctx_, g)  # use g.hidden_ctx_ tx or g.canvas_ctx_ ?
    canvasState.addAnnotation(shape)

    # append to #annotations for viewing
    for a, i in canvasState.annotations
      coordinates = "#{a.start}, #{a.finish}</br>"
      document.getElementById('annotations').innerHTML += coordinates if i is canvasState.annotations.length-1

normal_data = ([item['x'], item['y']] for item in light_curve_data)
iterator = 0
super_data = []
for num in [1..10]
  for item in light_curve_data
    super_data.push [item['x'] + iterator, item['y']]
  iterator += 35

graph = new Dygraph document.getElementById("graph"),
  # normal_data
  super_data

  drawPoints: true
  drawXGrid: true
  drawYGrid: false
  drawAxesAtZero: true
  strokeWidth: 0 # change to something like .1 to add lines between points
  width: 1000
  height: 400
  isZoomedIgnoreProgrammaticZoom: true
  showLabelsOnHighlight: false
  interactionModel:
    mousedown: Events.onMouseDown
    mousemove: Events.onMouseMove
    mouseup: Events.onMouseUp
    dblclick: Events.onDoubleClick
  showRangeSelector: true
  rangeSelectorHeight: 30
  rangeSelectorPlotStrokeColor: 'grey'
  rangeSelectorPlotFillColor: 'lightgrey'
  hideOverlayOnMouseOut: false
  # rollPeriod: 2
  # highlightCircleSize: 3
  highlightSeriesBackgroundAlpha: 1 #disable background fading on highlight changes
  highlightSeriesOpts: # remove highlight circle on hover
    highlightCircleSize: 0
    # pointSize: 0
  drawCallback: -> canvasState?.redrawMarks()
  underlayCallback: (canvas, area, g) ->
    # console.log "canvas", canvas, "Area", area, "g", g
    bottom_left = g.toDomCoords(0, -20)
    top_right = g.toDomCoords(area.w, +20)
    left = bottom_left[0]
    right = top_right[0]

    canvas.fillStyle = "#000";
    canvas.fillRect(left, area.y, right - left, area.h)

canvasState = new CanvasState(graph)
window.canvasState = canvasState
