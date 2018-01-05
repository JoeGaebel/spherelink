#= require applications/edit/small_spinner_view

class HeaderView
  constructor: (options = {}) ->
    @app = options.app
    $(document).ready(@onDocumentReady)

    @debouncedSetTitle = _.debounce(@_setTitle, 250, true)
    @debouncedSetDescription = _.debounce(@_setDescription, 250, true)

  onDocumentReady: =>
    @createUIHash()
    @bindHandlers()
    @setDefaultDescription()
    @setPrivacy()

  createUIHash: ->
    @ui =
      $titleWidget: $('.title-widget')
      $descriptionWidget: $('.description-widget')

      $titleLabel: $('#title')
      $descriptionLabel: $('#description')

      $titleInput: $('#title-input')
      $descriptionInput: $('#description-input')

      $privacyWidget: $('.privacy-widget')
      $privateLabel: $('.private')
      $publicLabel: $('.public')

  bindHandlers: ->
    @ui.$titleLabel.click(@onTitleLabelClick)
    @ui.$descriptionLabel.click(@onDescriptionLabelClick)

    @ui.$titleInput.blur(@debouncedSetTitle)
    @ui.$titleInput.keydown(@onTitleInputKeydown)

    @ui.$descriptionInput.blur(@debouncedSetDescription)
    @ui.$descriptionInput.keydown(@onDescriptionInputKeydown)

    @ui.$privateLabel.click(@onPrivateLabelClick)
    @ui.$publicLabel.click(@onPublicLabelClick)

  setDefaultDescription: ->
    if @ui.$descriptionLabel.text() == ""
      @ui.$descriptionLabel.text("Click to add a description")

  _setTitle: =>
    @ui.$titleInput.hide()

    spinner = new SmallSpinnerView
    @ui.$titleWidget.append(spinner.render())

    name = @ui.$titleInput.val()
    @sendDetails({ name }, @clearTitleSpinner)

  _setDescription: =>
    @ui.$descriptionInput.hide()

    spinner = new SmallSpinnerView
    @ui.$descriptionWidget.append(spinner.render())

    description = @ui.$descriptionInput.val()
    @sendDetails({ description }, @clearDescriptionSpinner)

  sendDetails: (details, successCallback) ->
    $.ajax
      url: "/memories/#{window.memory.id}/set_details"
      type: 'POST'
      dataType: 'json'
      contentType: 'application/json'
      data: JSON.stringify(details)
      error: @app.onAjaxError
      success: successCallback

  clearTitleSpinner: (response) =>
    $('.title-widget .small-spinner').remove()

    @ui.$titleLabel.text(response.name)
    @ui.$titleInput.val(response.name)

    @ui.$titleInput.hide()
    @ui.$titleLabel.show()

  clearDescriptionSpinner: (response) =>
    $('.description-widget .small-spinner').remove()

    @ui.$descriptionLabel.text(response.description)
    @ui.$descriptionInput.val(response.description)

    @ui.$descriptionInput.hide()
    @ui.$descriptionLabel.show()

  setPrivacy: ->
    if window.memory.private
      @ui.$privateLabel.show()
      @ui.$publicLabel.hide()
    else
      @ui.$publicLabel.show()
      @ui.$privateLabel.hide()


# Event Handlers


  onTitleLabelClick: =>
    @ui.$titleInput.val(@ui.$titleLabel.text())
    @ui.$titleInput.show()
    @ui.$titleInput.focus()

    @ui.$titleLabel.hide()

  onDescriptionLabelClick: =>
    @ui.$descriptionInput.val(@ui.$descriptionLabel.text())
    @ui.$descriptionInput.show()
    @ui.$descriptionInput.focus()

    @ui.$descriptionLabel.hide()

  onTitleInputKeydown: (e) =>
    @debouncedSetTitle() if e.keyCode == 13

  onDescriptionInputKeydown: (e) =>
    @debouncedSetDescription() if e.keyCode == 13

  onPrivateLabelClick: =>
    answer = confirm("Are you sure you want to make this memory public?")
    @sendDetails({ private: false }, @onPrivacyChangeSuccess) if answer

  onPublicLabelClick: =>
    answer = confirm("Are you sure you want to make this memory private?")
    @sendDetails({ private: true }, @onPrivacyChangeSuccess) if answer

  onPrivacyChangeSuccess: (response) =>
    window.memory.private = response.private
    @setPrivacy()


window.HeaderView = HeaderView
