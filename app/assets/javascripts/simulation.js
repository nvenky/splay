$(document).ready(function(){
  $('#simulationForm .input-group.date').datepicker({
    format: "dd/mm/yyyy",
    startDate: "01/07/2014",
    autoclose: true,
    todayHighlight: true
  });

  $('#simulationForm').on('ajax:success',function(event, responseData, status, xhr){
    data = responseData.chart_data
    var summaryData = _.rest(data[1]);
    var raceData = _.rest(data[0]);
    var totalRaces = _.size(raceData);
    var winningRaces = _.size(_.filter(raceData, function(num){ return num > 0; }));
    $('.summary .totalRaces').html(totalRaces);
    if (totalRaces != 0) {
      var summary = {
        totalRaces: totalRaces,
        winningRaces: winningRaces,
        winningPercentage: winningRaces/totalRaces * 100,
        profitLoss: _.last(summaryData),
        highestValue: _.max(summaryData),
        lowestValue: _.min(summaryData)

      };
      $('#graph').html(HandlebarsTemplates['simulations/graph'](responseData));
      drawGraph(data);
      $('#summary').html(HandlebarsTemplates['simulations/result_summary'](summary));
      //$('#details').html(HandlebarsTemplates['simulations/market_details_table'](responseData));
    } else{
      $('#summary').html(HandlebarsTemplates['simulations/no_results']());
      //$('#details').html('');
      $('#graph').html('');
    }
  }).on('ajax:error',function(xhr, status, error){
    alert('Failed');
  });


  $(document).ajaxStart(function(){
    $("#loadingOverlay").show();
  });

  $(document).ajaxStop(function(){
    $("#loadingOverlay").hide();
  });
});
