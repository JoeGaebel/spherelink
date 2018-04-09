class SphereView
  constructor: (options = {}) ->
    { @id, @thumb, @caption, @hideCan } = options

  render: ->
    @template()

  template: ->
    """
      <div id="sphere-#{ @id }" class="sphere-item-view">
        <div id="#{ @id }" class="glyphicon glyphicon-trash delete-sphere delete-shadow #{ "hidden" if @hideCan }"></div>
        <div id="#{ @id }" class="glyphicon glyphicon-trash delete-sphere #{ "hidden" if @hideCan }"></div>
        <a href="javascript:;" id="#{ @id }" class="sphere-link">
          <img src="#{ @thumb }">
        </a>
        <div class="caption">#{ _.escape(@caption) }</div>
      </div>
    """

window.SphereView = SphereView
