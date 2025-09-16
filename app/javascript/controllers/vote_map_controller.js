import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["region"]

  connect() {
    this.regionTargets.forEach(el => {
      const rate = parseFloat(el.dataset.rate)
      // 色をグラデーションで変化
      const red = Math.min(255, Math.round(rate * 2.55))
      el.style.backgroundColor = `rgb(${red},0,0,0.5)`
    })
  }
}
