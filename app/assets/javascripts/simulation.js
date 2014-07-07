$(document).ready(function(){
  $('#simulationForm').on('ajax:success',function(event, data, status, xhr){
    var summaryData = data[1];
    $('#finalAmount').html('PROFIT/LOSS: ' + summaryData[summaryData.length - 1]);
    drawGraph(data);
  }).on('ajax:error',function(xhr, status, error){
    alert('Failed');
  });
});
