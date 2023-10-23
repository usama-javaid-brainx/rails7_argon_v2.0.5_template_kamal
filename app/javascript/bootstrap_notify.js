import 'bootstrap-notify'

const showNotification = window.showNotification = (title = 'Notification', message = '', type = 'success', delay = 1000) => {
    if (message == null || message === '') {
        return
    }
    $.notify({
        // options
        icon: 'ni ni-bell-55',
        title: title,
        message: message.replace('\n', '<br/>')
    }, {
        // settings
        element: 'body',
        position: 'fixed',
        type: type,
        delay: delay,
        placement: {
            from: 'top',
            align: 'center'
        },
        offset: {x: 0, y: 60},
        mouse_over: 'pause',
        template: '<div data-notify="container" class="alert alert-dismissible alert-notify-{0} alert-notify" role="alert">' +
            '<span class="alert-icon" data-notify="icon"></span> ' +
            '<div class="alert-text font-proxima-nova"</div> ' +
            '<span class="alert-title" data-notify="title">{1}</span> ' +
            '<span data-notify="message">{2}</span>' +
            '</div>' +
            '<button type="button" class="close" data-notify="dismiss" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
            '</div>'
    })
}