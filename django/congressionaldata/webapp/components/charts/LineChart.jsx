import React, { Component } from 'react'
import { scaleLinear, scaleBand } from 'd3-scale';
import { max } from 'd3-array'
import { select, selectAll } from 'd3-selection'
import { axisBottom, axisLeft } from 'd3-axis'

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

        const x = scaleTime()
            .rangeRound([0, width])
            .padding(0.1)

        const y = scaleLinear()
            .rangeRound([height, 0])
			
		const line = d3.line()
			.x.domain(data.map(d => d[xKey]))
			.y.domain([0, max(data, d => +d[yKey])]).nice();
		
		const g = select(this.svg).append('g');
		
		g.append("g")
		    .attr("transform", "translate(0," + height + ")")
		    .call(d3.axisBottom(x))
		 .select(".domain")
		    .remove();

		g.append("g")
			.call(d3.axisLeft(y))
		 .append("text")
			.attr("fill", "#000")
			.attr("transform", "rotate(-90)")
			.attr("y", 6)
			.attr("dy", "0.71em")
			.attr("text-anchor", "end")
			.text("Price ($)");

		g.append("path")
			.datum(data)
			.attr("fill", "none")
			.attr("stroke", "steelblue")
			.attr("stroke-linejoin", "round")
			.attr("stroke-linecap", "round")
			.attr("stroke-width", 1.5)
			.attr("d", line);
        g.selectAll()
            .data(data)
            .enter().append('rect')
                .attr('fill', barColor)
                .attr('x', d => x(d[xKey]))
                .attr('y', d => y(d[yKey]))
                .attr('width', x.bandwidth())
                .attr('height', d => height - margin.bottom - y(d[yKey]))
				.attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
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
