import { Controller } from 'stimulus';
import Chart from 'chart.js/auto';
import ChartDataLabels from 'chartjs-plugin-datalabels';

export default class extends Controller {
  static targets = [
    'dateRangeData',
    'productivityData',
    'productivityChart',
    'happinessData',
    'happinessChart',
    'valuesData',
    'valuesChart',
  ];

  constructor(...args) {
    super(...args);

    this.skipped = (ctx, value) =>
      ctx.p0.skip || ctx.p1.skip ? value : undefined;
    this.down = (ctx, value) =>
      ctx.p0.parsed.y > ctx.p1.parsed.y ? value : undefined;
    this.genericOptions = {
      plugins: {
        legend: {
          display: false,
        },
      },
      fill: false,
      interaction: {
        intersect: false,
      },
      radius: 0,
      scales: {
        x: {
          display: false,
        },
        y: {
          min: 0,
          display: true,
          ticks: {
            color: '#8d8d8d',
          },
          grid: {
            display: false,
          },
        },
      },
    };
  }

  connect() {
    this.noDataText = 'You have no Commmits for the previous 7 days.';

    this._generateProductivityChart();
    this._generateHappinessChart();
    this._generateValuesChart();
  }

  _generateProductivityChart() {
    const config = {
      type: 'line',
      data: {
        datasets: [
          {
            label: 'Productivity',
            data: JSON.parse(this.productivityDataTarget.value),
            borderColor: 'rgb(75, 192, 192)',
            segment: {
              borderColor: (ctx) =>
                this.skipped(ctx, 'rgb(0,0,0,0.2)') ||
                this.down(ctx, 'rgb(192,75,75)'),
              borderDash: (ctx) => this.skipped(ctx, [6, 6]),
            },
            tension: 0.3,
          },
        ],
      },
      options: this.genericOptions,
    };

    new Chart(this.productivityChartTarget, config);
  }

  _generateHappinessChart() {
    const config = {
      type: 'line',
      data: {
        datasets: [
          {
            label: 'Happiness',
            data: JSON.parse(this.happinessDataTarget.value),
            borderColor: 'rgb(75, 192, 192)',
            segment: {
              borderColor: (ctx) =>
                this.skipped(ctx, 'rgb(0,0,0,0.2)') ||
                this.down(ctx, 'rgb(192,75,75)'),
              borderDash: (ctx) => this.skipped(ctx, [6, 6]),
            },
            tension: 0.3,
          },
        ],
      },
      options: {
        ...this.genericOptions,
        scales: {
          ...this.genericOptions.scales,
          y: {
            ...this.genericOptions.scales.y,
            min: 1,
            ticks: {
              ...this.genericOptions.scales.y.ticks,
              precision: 0,
            },
          },
        },
      },
    };

    new Chart(this.happinessChartTarget, config);
  }

  _generateValuesChart() {
    const config = {
      type: 'bar',
      plugins: [ChartDataLabels],
      data: {
        labels: JSON.parse(this.dateRangeDataTarget.value),
        datasets: JSON.parse(this.valuesDataTarget.value),
      },
      options: {
        plugins: {
          legend: {
            labels: {
              color: '#8d8d8d',
            },
          },
          datalabels: {
            color: 'white',
            display: function (context) {
              return context.dataset.data[context.dataIndex] > 0;
            },
            font: {
              weight: 'bold',
            },
          },
          title: {
            display: false,
          },
        },
        responsive: true,

        scales: {
          x: {
            display: false,
            stacked: true,
          },
          y: {
            display: false,
            stacked: true,
          },
        },
      },
    };

    new Chart(this.valuesChartTarget, config);
  }
}
