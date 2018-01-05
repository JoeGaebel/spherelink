class BaseView
  viewClass: null

  hide: -> $(@viewClass).hide()

  show: -> $(@viewClass).show()

window.BaseView = BaseView
