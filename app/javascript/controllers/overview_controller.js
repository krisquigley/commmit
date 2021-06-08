import { Controller } from 'stimulus';
import ApexCharts from 'apexcharts';

export default class extends Controller {
  static targets = [
    'dateRangeData',
    'productivityData',
    'productivityChart',
    'happinessData',
    'happinessChart',
    'valuesData',
    'valuesColorData',
  ];

  connect() {
    this._generateProductivityChart();
    this._generateHappinessChart();
  }

  _generateProductivityChart() {
    const options = {
      series: JSON.parse(this.valuesDataTarget.value).concat([
        {
          name: 'Productivity',
          type: 'line',
          color: '#018ffa',
          data: JSON.parse(this.productivityDataTarget.value),
        },
      ]),
      chart: {
        background: 'none',
        toolbar: {
          show: false,
        },
        type: 'line',
        minHeight: 350,
        stacked: true,
        dropShadow: {
          enables: false,
        },
      },
      plotOptions: {
        bar: {
          horizontal: false,
        },
      },
      colors: JSON.parse(this.valuesColorDataTarget.value),
      theme: {
        mode: 'dark',
        palette: 'palette1',
      },
      grid: {
        show: false,
      },
      dataLabels: {
        enabled: true,
      },
      xaxis: {
        type: 'category',
        categories: JSON.parse(this.dateRangeDataTarget.value),
        labels: {
          show: false,
        },
        axisBorder: {
          show: false,
        },
        axisTicks: {
          show: false,
        },
      },
      yaxis: {
        logarithmic: false,
        axisBorder: {
          show: false,
        },
        axisTicks: {
          show: false,
        },
        labels: {
          show: false,
          formatter: function (value) {
            return Math.trunc(value);
          },
        },
      },
      legend: {
        show: true,
        position: 'top',
      },
    };
    const valuesChart = new ApexCharts(this.productivityChartTarget, options);

    valuesChart.render();
  }

  _generateHappinessChart() {
    const options = {
      theme: {
        mode: 'dark',
        palette: 'palette1',
      },
      chart: {
        background: 'none',
        toolbar: {
          show: false,
        },
        type: 'line',
      },
      stroke: {
        curve: 'smooth',
      },
      series: [
        {
          name: 'Happiness',
          data: JSON.parse(this.happinessDataTarget.value),
        },
      ],
      dataLabels: {
        enabled: true,
      },
      grid: {
        show: false,
      },
      yaxis: {
        logarithmic: false,
        axisTicks: {
          show: false,
        },
        labels: {
          show: false,
        },
      },
      xaxis: {
        tooltip: {
          enabled: false,
        },
        labels: {
          show: false,
        },
        axisBorder: {
          show: false,
        },
        axisTicks: {
          show: false,
        },
      },
    };

    const happinessChart = new ApexCharts(this.happinessChartTarget, options);

    happinessChart.render();
  }
}
