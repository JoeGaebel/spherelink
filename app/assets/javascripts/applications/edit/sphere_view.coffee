class SphereView
  constructor: (options = {}) ->
    { @id, @thumb, @caption } = options

  render: ->
    @template()

  template: ->
    """
      <div id="sphere-#{ @id }" class="sphere-item-view">
        <div id="#{ @id }" class="glyphicon glyphicon-trash delete-sphere delete-shadow"></div>
        <div id="#{ @id }" class="glyphicon glyphicon-trash delete-sphere"></div>
        <a href="javascript:;" id="#{ @id }" class="sphere-link">
          <img src="#{ @thumb }">
        </a>
        <div class="caption">#{ _.escape(@caption) }</div>
      </div>
    """

window.SphereView = SphereView
