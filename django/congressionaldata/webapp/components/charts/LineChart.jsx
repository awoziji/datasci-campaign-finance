import React, { Component } from 'react'
import { scaleLinear, scaleBand, scaleTime } from 'd3-scale';
import { max } from 'd3-array'
import { select, selectAll } from 'd3-selection'
import { axisBottom, axisLeft } from 'd3-axis'
import { line } from 'd3-shape'

class LineChart extends Component {

    componentDidMount() {
        this.createChart();
    }

    componentDidUpdate() {
        select(this.svg).selectAll('g').remove(); // Refresh the chart.
        this.createChart();
    }

    createChart = () => {
        const { width, height, xKey, yKey, barColor, data } = this.props;
        const margin = {top: 20, right: 20, bottom: 30, left: 50};

        const xScale = scaleLinear()
	    .domain([0, 20])
            .range([0, width]);
            //.padding(0.1)

        const yScale = scaleLinear()
	    .domain([0,1])
            .range([height, 0]);
			
	const line = line()
		.x(function(d, i){return xScale(i);})
		.y(function (d){return yScale(d.y); });
		//.x.domain(data.map(d => d[xKey]))
		//.y.domain([0, max(data, d => +d[yKey])]).nice();
		
	const g = select(this.svg).append('g');
		
	g.append("g")
	    .attr("transform", "translate(0," + height + ")")
	    .call(axisBottom(xScale))
	 .select(".domain")
	    .remove();

	g.append("g")
		.call(axisLeft(yScale))
	 .append("text")
		.attr("fill", "#000")
		.attr("transform", "rotate(-90)")
		.attr("y", 6)
		.attr("dy", "0.71em")
		.attr("text-anchor", "end")
		.text("Price ($)");

	g.append("path")
		.datum(data)
		.attr("class", "line")
		.attr("d", line)
        g.selectAll(".dot")
	    .data(dataset)
	  .enter().append("circle") // Uses the enter().append() method
	    .attr("class", "dot") // Assign a class for styling
	    .attr("cx", function(d, i) { return xScale(i) })
	    .attr("cy", function(d) { return yScale(d.y) })
	    .attr("r", 5);
   }
    render() {
	const { width, height } = this.props;
        return <svg ref={node => this.svg = node}
            width={width}
            height={height}>
        </svg>
    }
}
export default LineChart
