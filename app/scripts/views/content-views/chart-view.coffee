util = require '../../helpers/graph-util.coffee'
d3 = require 'd3'
data = require './../../../../assets/data/votes_month.json'
class ChartView extends Marionette.ItemView
  template: require './chart-view.jade'
  model: "BillModel"


  initialize: ->

  @defaults: ->
    margin = 
      top: 30
      right: 10
      bottom: 10
      left: 10

  render: ->
    data = data.results.votes

    parseDate = d3.time.format("%Y-%m-%dT%H:%M:%SZ").parse

    margin = 
      top: 30
      right: 10
      bottom: 10
      left: 10

    width = $("#chart").width() - margin.right - margin.left

    height = data.length * 10

    #Set the scale
    x = d3.scale.linear()
      .range([0, width])

    y = d3.scale.ordinal()
      .rangeRoundBands([0, height], .2)

    makePositive = (x)->
      Math.abs x

    xAxis = d3.svg.axis().scale(x)
      .orient("top").tickValues([-250, -200, -150, -100, -50 , 0, 50, 100, 150, 200, 250]).tickFormat(makePositive)

    svg = d3.select(@el).append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
        .attr("transform","translate(" +
          margin.left + "," + margin.top + ")")

    dataFix = data.reduce((acc, vote) ->
      acc.concat [
        {
          yes: vote.democratic.yes * -1
          vote: vote
        }
        {
          yes: vote.republican.yes * 1
          vote: vote
        }
      ]
    , [])

    console.log dataFix

    x.domain d3.extent([-250,250])

    #what's this line doing?
    y.domain data.map (d) ->
      d.description

    svg.selectAll(".bar")
        .data(dataFix)
      .enter().append("rect")
        .attr("class", (d) ->
          if d.yes < 0 then "bar negative" else "bar positive")
        .attr("x", (d) ->
          x Math.min(0, d.yes))
        .attr("y", (d) ->
          y(d.vote.description))
        .attr("width", (d) ->
          Math.abs x(d.yes) - x(0))
        .attr( "height", y.rangeBand())

    svg.append("g")
      .attr("class", "x axis")
      .call(xAxis)

    svg.append("g")
        .attr("class", "y axis")
      .append("line")
        .attr("x1", x(0))
        .attr("x2", x(0))
        .attr("y2", height)



module.exports = ChartView
