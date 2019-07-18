const uuidv1 = require('uuid/v1')

const generateCSV = document.querySelector("a[data-behavior='generateCSV']")
const downloadCSVLink = document.querySelector("a[data-behavior='downloadCSV']")
const generateCSVMessage = document.querySelector("span[data-behavior='generateCSVMessage']")
const url = window.location.pathname.split('/')
const slug = url[url.length - 1]

const exportCSV = () => {
  const uuid = uuidv1()
  generateCSV.style.display = "none"
  generateCSVMessage.style.display = "initial"
  fetch(`/sprints/${slug}/export_csv?uuid=${uuid}`, {
    method: 'POST'
  }).then(async response => {
    console.log(response)
    if (response.status === 200) {
      const downloadCSV = setTimeout(async () => {
        const download = await fetch(`/sprints/${slug}/download_csv?uuid=${uuid}`)
        if (download.response === 404) {
          downloadCSV()
        } else {
          generateCSVMessage.style.display = "none"
          downloadCSVLink.href = `/sprints/${slug}/download_csv?uuid=${uuid}`
          downloadCSVLink.style.display = "initial"
        }
      }, 2000)
    }
  })
}

generateCSV.addEventListener('click', exportCSV)