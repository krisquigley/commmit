import { Controller } from 'stimulus';
import ApexCharts from 'apexcharts';

export default class extends Controller {
  static targets = [
    'productivityData',
    'productivityChart',
    'happinessData',
    'happinessChart',
  ];

  connect() {
    this._generateProductivityChart();
    this._generateHappinessChart();
  }

  _generateProductivityChart() {
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
          name: 'Productivity',
          data: JSON.parse(this.productivityDataTarget.value),
        },
      ],
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

    const productivityChart = new ApexCharts(
      this.productivityChartTarget,
      options,
    );

    productivityChart.render();
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
