class App.FormUploader

  defaultOptions:
    runtimes: 'gears,silverlight,html5,flash'
    browse_button: 'browse'
    multi_selection: false
    multipart: true

  file: null

  constructor: (el, options = {})->
    console.log('init')
    @$el = el
    @options = _.extend {}, @defaultOptions, options
    @submitButton = @$('button#submit')
    @submitButton.on 'click', @ajaxSave
    @cancelButton = @$('.btn.cancel')
    @cancelButton.on 'click', @cancel
    @$('#content_title').on 'blur', => @reValidate('title')

    @initPlupload()

  $: (path)->
    @$el.find(path)

  initPlupload: ->
    @uploader ||= new plupload.Uploader _.extend({}, @options, {
      init:
        FilesAdded: @filesAdded
        UploadProgress: @uploadProgress
        FileUploaded: @success
    })
    @uploader.init()

  filesAdded: (up, files)=>
    @file = files[0]
    @reValidate('file')
    @$('.loader .name').text("#{@file.name} (#{plupload.formatSize(@file.size)})")
    @$('.loader').removeClass('hidden')
    @$('.browse').addClass('hidden')

  cancel: =>
    @uploader.stop()
    @uploader.removeFile(@file) if @file
    @file = null
    @reValidate('file')
    @$('.progress-bar').width(0)
    @$('.loader').addClass('hidden')
    @$('.browse').removeClass('hidden')

  uploadProgress: (up, file)=>
    @$('.progress-bar').css('width': "#{file.percent}%").text("#{file.percent}%")

  success: (event, file, resp)=>
    resp = JSON.parse(resp.response)
    if resp.errors
      @handleErrors(resp.errors)
    else
      window.location = resp.location

  valid: ->
    @errors = {}
    @errors.title = 'не может быть пустым' if _.isEmpty @$("#content_title").val()
    @errors.file = 'не может быть пустым' if _.isNull @file
    return true if _.isEmpty(@errors)

  showOrHideErrors: (target)->
    fields = if target then [target] else ['title', 'file']
    _.each fields, (field)=>
      $element = @$(".content_#{field}")
      $element.parent().find('.text-danger').remove()
      if @errors[field]
        $('<div>').addClass('text-danger small').text(@errors[field]).insertAfter($element)
        $element.parents('.form-group').removeClass('has-success').addClass('has-error')
      else
        $element.parents('.form-group').removeClass('has-error').addClass('has-success')

  reValidate: (field)=>
    @valid()
    @showOrHideErrors(field)

  multipartParams: ->
    title: @$("#content_title").val()
    tags: @$("#content_tags").val()
    authenticity_token: @$("[name='authenticity_token']").val()

  ajaxSave: (e)=>
    e.preventDefault()
    return @showOrHideErrors() unless @valid()
    @uploader.setOption 'multipart_params', @multipartParams()
    @uploader.start()




