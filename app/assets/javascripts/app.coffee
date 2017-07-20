@App =
  name: 'Bakofin'

  init: ()->
    console.info "#{@name} initialized"
    $(document).on 'turbolinks:load', ()=>
      @highstock()

  highstock: ()->
    $.getJSON('/quotes', (result)->
      quotes = $.parseJSON result.quotes
      volumes = $.parseJSON result.volumes

      myChart = Highcharts.stockChart('chart', {
        title: {
          useHTML: true,
          text: "XAUUSD H1"
        },
        tooltip: {
          split: true
        },
        xAxis: {
          gridLineWidth: 1,
          gridLineDashStyle: 'dash',
          minTickInterval: 1,
          tickInterval: 60
        },
        yAxis: [{
          type: 'logarithmic',
          labels: {
            align: 'right',
            x: -3
          },
          title: {
            text: 'OHLC'
          },
          height: '60%',
          lineWidth: 2
        }, {
          labels: {
            align: 'right',
            x: -3
          },
          title: {
            text: 'Volume'
          },
          top: '65%',
          height: '35%',
          offset: 0,
          lineWidth: 2
        }]
        ,
        series: [
          {
            name: 'XAUUSD',
            type: "candlestick",
            data: quotes,
            animation: false
          },
          {
            name: 'Volume',
            type: 'column',
            data: volumes,
            yAxis: 1,
            animation: false
          }
        ],
        rangeSelector: {
          allButtonsEnabled: true,
          buttons: [
            {
              type: 'day',
              count: 1,
              text: '1d'
            },
            {
              type: 'week',
              count: 1,
              text: '1w'
            },
            {
              type: 'month',
              count: 1,
              text: '1m'
            },
            {
              type: 'month',
              count: 3,
              text: '3m'
            },
            {
              type: 'all',
              text: 'all'
            }
          ],
          selected: 1
        },
        plotOptions: {
          series: {
            dataGrouping: {
              enabled: false
            }
          }
        },
        credits: {
          href: 'http://0.0.0.0:3000',
          text: 'Bakofin'
        }
      })
    )

App.init()