// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "./jquery"
import "./bootstrap_notify"
import "jquery-ujs"


document.addEventListener('DOMContentLoaded', renderFlashMessage)
document.addEventListener("turbo:render", renderFlashMessage)

function renderFlashMessage(){
    const flashMessage = document.getElementById('flashMessages')
    if (flashMessage) {
        showNotification('Notification', flashMessage.dataset.message, flashMessage.dataset.messageType, flashMessage.dataset.messageType === 'danger' ? 3000 : 4000)
        flashMessage.remove()
    }
}