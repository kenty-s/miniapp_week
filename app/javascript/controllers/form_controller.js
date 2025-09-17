import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["option", "form"]

  selectOption(event) {
    // ラジオボタン自体がクリックされた場合は何もしない（通常の動作に任せる）
    if (event.target.type === 'radio') {
      return
    }

    // 同じフォーム内の他の選択肢の選択状態をクリア
    this.optionTargets.forEach(option => {
      option.classList.remove('selected')
      const radio = option.querySelector('input[type="radio"]')
      if (radio) {
        radio.checked = false
      }
    })

    // クリックされた選択肢を選択状態にする
    const clickedOption = event.currentTarget
    clickedOption.classList.add('selected')

    // ラジオボタンをチェック
    const radioButton = clickedOption.querySelector('input[type="radio"]')
    if (radioButton) {
      radioButton.checked = true
    }

    // 少し待ってから自動で次のページに進む
    setTimeout(() => {
      this.formTarget.submit()
    }, 300)
  }

  // ラジオボタンが直接クリックされた時の処理
  radioSelected(event) {
    // 同じフォーム内の他の選択肢の選択状態をクリア
    this.optionTargets.forEach(option => {
      option.classList.remove('selected')
    })

    // 選択されたラジオボタンの親要素を選択状態にする
    const parentOption = event.target.closest('[data-form-target="option"]')
    if (parentOption) {
      parentOption.classList.add('selected')
    }

    // 少し待ってから自動で次のページに進む
    setTimeout(() => {
      this.formTarget.submit()
    }, 300)
  }
}