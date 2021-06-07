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
    'valuesChart',
  ];

  connect() {
    this._generateProductivityChart();
    this._generateHappinessChart();
    this._generateValuesChart();
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
      dataLabels: {
        enabled: true,
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

  _generateValuesChart() {
    const options = {
      series: JSON.parse(this.valuesDataTarget.value),
      chart: {
        background: 'none',
        toolbar: {
          show: false,
        },
        type: 'bar',
        height: 350,
        stacked: true,
        stackType: '100%',
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
      xaxis: {
        type: 'datetime',
        categories: JSON.parse(this.dateRangeDataTarget.value),
        axisBorder: {
          show: true,
        },
        axisTicks: {
          show: true,
        },
      },
      yaxis: {
        logarithmic: false,
        axisTicks: {
          show: false,
        },
        labels: {
          show: true,
        },
      },
      legend: {
        show: false,
        position: 'top',
      },
    };
    const valuesChart = new ApexCharts(this.valuesChartTarget, options);

    valuesChart.render();
  }
}
