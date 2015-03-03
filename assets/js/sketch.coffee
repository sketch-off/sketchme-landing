---
---
modes = {
    ADR: 0,
    iOS: 1
}
submit_mode = modes.iOS
# base_url = 'http://0.0.0.0:3000'
base_url = 'http://inception-landing.herokuapp.com'
$input = $('#input-text')
$output = $('#output')
$prefix = $('#input-prefix')
$btnSubmit = $('#btn-submit')
$appstore = $('.appstore')
$android = $('.android')
$boxes = $('.boxes').children()

renderMode = ->
    # uaStr = navigator.userAgent
    if submit_mode == modes.ADR
        $btnSubmit.html 'Sign up'
        $input.attr 'placeholder', 'Email address'
        $input.val ''
        $input.unmask()
        $android.addClass 'active'
        $appstore.removeClass 'active'
        $prefix.hide()
    else if submit_mode == modes.iOS
        $btnSubmit.html 'Get download link'
        $input.attr 'placeholder', 'Phone number'
        $input.mask '(000) 000-0000'
        $input.val ''
        $appstore.addClass 'active'
        $android.removeClass 'active'
        $prefix.show()

$('#appstore').click (e) ->
    # if iOS, allow link
    if submit_mode == modes.ADR
        submit_mode = modes.iOS
        e.preventDefault()
    renderMode()

$('#android').click ->
    # if Android, do nothing
    if submit_mode == modes.iOS
        submit_mode = modes.ADR
    renderMode()

$btnSubmit.click ->
    if submit_mode == modes.ADR
        submitEmail()
    else if submit_mode == modes.iOS
        submitPhone()

$ ->
    renderMode()
    equalHeightWidth $('.sketch-main')
    equalHeightWidth $('.sketch-overlay')
    w = $('.sketch-detail').width()
    console.log w
    $('.sketch-img').width w

equalHeightWidth = ($e) ->
    $e.css 'height': $e.width()

submitPhone = ->
    $output.slideUp()
    $.ajax
        type: 'POST'
        url: base_url + '/sms'
        crossDomain: true
        data:
            number: $input.cleanVal()
        error: (xhr) ->
            if xhr.status == 429
                $output.html 'Whoa slow down... Try again in a minute.'
            else
                $output.html 'Error occured when we attempted to text you.'
            $output.slideDown()
        success: (xhr) ->
            $output.html 'Great! Now download SketchOff on your phone!'
            $output.slideDown()

submitEmail = ->
    $output.slideUp()
    $.ajax
        type: 'POST'
        url: base_url + '/submit'
        crossDomain: true
        data:
            email: $input.val()
        error: (xhr) ->
            err = $.parseJSON xhr.responseText
            console.log err
            if err.name == 'MongoError' and err.code == 11000
                $output.html 'You have already signed up!'
            else
                $output.html 'Error occured when signing up.'
            $output.slideDown()
        success: (xhr) ->
            $output.html 'Great! We will send you an email when we launch!'
            $output.slideDown()
