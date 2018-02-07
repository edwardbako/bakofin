@App =
  name: 'Bakofin'
  myChart: undefined

  init: ()->
    console.info "#{@name} initialized"
    $(document).on 'turbolinks:load', ()=>
      @highstock()

  highstock: ()->
    $.getJSON('/quotes', (result)->
      quotes = $.parseJSON result.quotes
      volumes = $.parseJSON result.volumes

      App.myChart = Highcharts.stockChart('chart', {
        title: {
          useHTML: true,
          text: "XAUUSD M1"
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
          type: 'logarithmic', #'logarithmic'
          labels: {
            align: 'right',
            x: -3
          },
          title: {
            text: 'OHLC'
          },
          height: '80%',
          lineWidth: 2
        }, {
          labels: {
            align: 'right',
            x: -3
          },
          title: {
            text: 'Volume'
          },
          top: '85%',
          height: '15%',
          offset: 0,
          lineWidth: 2
        }]
        ,
        series: [
          {
            id: 'qq',
            name: 'XAUUSD',
            type: "candlestick",
            data: quotes,
            animation: {duration: 0}
          },
          {
            name: 'Volume',
            type: 'column',
            data: volumes,
            yAxis: 1,
            animation: {duration: 0}
          },
          {
            type: 'bb',
            linkedTo: 'qq'
          }
        ],
        chart: {
          animation: {duration: 100, easing: "swing"},
          events: {
            load: ()->
              setInterval((()=>
                q = @.series[0]
                v = @.series[1]
                l = q.points.length
                $.getJSON('/quotes/0', (result)=>
                  points = {
                    quotes: $.parseJSON result.quotes
                    volumes: $.parseJSON result.volumes
                  }
                  last = {
                    quotes: q.points[l-1]
                    volumes: v.points[l-1]
                  }
                  prev = {
                    quotes: q.points[l-1]
                    volumes: v.points[l-1]
                  }
                  if last.quotes.x != points.quotes[1].x
                    q.addPoint(points.quotes[1])
                    v.addPoint(points.volumes[0])
                    prev.quotes.update(points.quotes[0])
                    prev.volumes.update(points.volumes[0])
                  else
                    last.quotes.update(points.quotes[1])
                    last.volumes.update(points.volumes[1])

#                  console.log l
#                  console.log last.quotes.x == point.quotes.x
                )
              ), 1000)
          }
        },
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
          column: {
            animation: {duration: 0}
          },
          candlestick: {
            animation: {duration: 0}
          },
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