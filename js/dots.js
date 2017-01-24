function addEmptyDot(svg, x, y, r, w) {
    var g = addGroup(svg);
    var w = w || 1;
    var r = r || 5;
       g.append('circle')
          .attr('cx', x)
          .attr('cy', y)
          .attr('r', r+w)
          .style('fill', 'black')
          .attr('inner', 'f');
       g.append('circle')
          .attr('cx', x)
          .attr('cy', y)
          .attr('r', r-w)
          .style('fill', 'white')
          .attr('inner', 't');;
       g.attr('r', r);
       g.attr('w', w);
       return g;
    }
    
    function addGroup(svg) {
      return svg.append('g');
    }
    var svg = d3.select('svg');
    for (var i = 0; i<10; i++) {
      addEmptyDot(d3.select('svg'), 80+ i*Math.random()*10,40+Math.random()*i*10, 3);
    }