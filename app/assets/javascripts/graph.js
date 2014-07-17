var drawGraph = function(data){
  c3.generate({
    bindto: '#chart',
    data: {
      columns: [ data[0], data[1] ]
    },
    grid: {
      y: {
        lines: [{value: 0, text: '0 AXIS'}]
      }
    },
    axis : {
      x : {
        tick: {
          //format: d3.format("$,")
          format: function (d) { return d + 1; }
        }
      }
    }

  });
};
