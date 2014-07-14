$(document).ready(function(){
  $('#simulationForm .input-group.date').datepicker({
    format: "dd/mm/yyyy",
    startDate: "01/07/2014",
    autoclose: true,
    todayHighlight: true
  });

  $('#simulationForm').on('ajax:success',function(event, data, status, xhr){
    var summaryData = data[1];
    $('#finalAmount').html('PROFIT/LOSS: ' + summaryData[summaryData.length - 1]);
    //$('#lowestValue').html('LOWEST: ' + Math.min.apply(Math, data[1].splice(0,1)));
    //$('#highestValue').html('HIGHEST: ' + Math.max.apply(Math, data[1].splice(0,1)));
    drawGraph(data);
  }).on('ajax:error',function(xhr, status, error){
    alert('Failed');
  });
});
