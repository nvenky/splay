$(document).ready(function(){
  $('#simulationForm .input-group.date').datepicker({
    format: "dd/mm/yyyy",
    startDate: "01/07/2014",
    autoclose: true,
    todayHighlight: true
  });

  $('#simulationForm').on('ajax:success',function(event, data, status, xhr){
    var summaryData = _.rest(data[1]);
    var raceData = _.rest(data[0]);
    var totalRaces = _.size(raceData);
    var winningRaces = _.size(_.filter(raceData, function(num){ return num > 0; }));
    $('.summary .totalRaces').html(totalRaces);
    $('.summary .winningRaces').html(winningRaces);
    $('.summary .winningPercentage').html(winningRaces/totalRaces * 100);
    $('.summary .profitLoss').html(_.last(summaryData));
    $('.summary .highestValue').html(_.max(summaryData));
    $('.summary .lowestValue').html(_.min(summaryData));
    drawGraph(data);
  }).on('ajax:error',function(xhr, status, error){
    alert('Failed');
  });


  // when an ajax request starts, show spinner
  $(document).ajaxStart(function(){
    $("#loadingOverlay").show();
  });

  // when an ajax request complets, hide spinner
  $(document).ajaxStop(function(){
    $("#loadingOverlay").hide();
  });
});
