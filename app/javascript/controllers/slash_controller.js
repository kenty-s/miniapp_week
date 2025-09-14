import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "slash" ]

  connect() {
    this.triggered = false
    // クリック
    const btn = document.getElementById("start-btn")
    btn.addEventListener("click", () => this.animateSlash())
    // スクロール
    window.addEventListener("scroll", () => this.animateSlash())
  }

  animateSlash() {
    if (this.triggered) return
    this.triggered = true
    const slash = document.querySelector(".slash-img")
    slash.style.opacity = 1
    slash.style.transform = "rotate(0deg) scale(1)"
    setTimeout(() => {
      // 次ページ遷移もしくはボタン活性化
      // ここでは開始ボタンでリンクに飛べるので不要
    }, 800)
  }
}
