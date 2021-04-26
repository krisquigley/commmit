import { Controller } from 'stimulus';
import ApexCharts from 'apexcharts';

export default class extends Controller {
  static targets = ['productivityData', 'chart'];

  connect() {
    console.log('here');
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
        logarithmic: true,
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

    const chart = new ApexCharts(this.chartTarget, options);

    chart.render();
  }
}
