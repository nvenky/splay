var drawGraph = function(data){
  c3.generate({
    bindto: '#chart',
    data: {
      columns: [ data[0], data[1] ]
    },
    types: {
        Winnings: 'bar'
    }
});
};
