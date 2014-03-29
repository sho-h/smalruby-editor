# ロードダイアログを表現するビュー
Smalruby.LoadModalView = Backbone.View.extend
  events:
    'click #load-modal-ok-button': 'onOk'

  initialize: ->
    @$el.find('#load-modal-find-from-computer').click (e) =>
      e.preventDefault()
      @onFindFromComputerClick.call(@, e)

  render: ->
    @type = null
    @program = null
    @unselect()

    elLocalPrograms = @$el.find('#load-modal-local-programs')
    elLocalPrograms.empty()

    elDemoPrograms = @$el.find('#load-modal-demo-programs')
    elDemoPrograms.empty()

    @$el.find('.modal-body').block
      message: null

    unblock = =>
      @$el.find('.modal-body').unblock()

    @$el.modal('show')

    dfr = $.Deferred()
    $.ajax
      url: '/source_codes/'
      type: 'GET'
      dataType: 'json'
      success: (data, textStatus, jqXHR) -> dfr.resolve(data)
      error: dfr.reject
    dfr.promise()
      .then (data) =>
        for program in data.localPrograms
          do (program) =>
            html = @programToHtml(program, @onLocalProgramClick)
            elLocalPrograms.append(html)

        for program in data.demoPrograms
          do (program) =>
            html = @programToHtml(program, @onDemoProgramClick)
            elDemoPrograms.append(html)

      .then(unblock, unblock)
      .fail =>
        @$el.modal('hide')
        errorMessage('ロードに失敗しました')

  onOk: ->
    switch @type
      when 'local'
        $.ajax
          url: '/source_codes/load_local'
          type: 'POST'
          data:
            source_code:
              filename: @program.filename
          dataType: 'json'
          success: (data, textStatus, jqXHR) ->
            Smalruby.Views.MainMenuView.load(data.source_code)

      when 'demo'
        $.ajax
          url: '/source_codes/load_demo'
          type: 'POST'
          data:
            source_code:
              filename: @program.filename
          dataType: 'json'
          success: (data, textStatus, jqXHR) ->
            Smalruby.Views.MainMenuView.load(data.source_code)

      when 'find-from-computer'
        $('input#load-file[name="source_code[file]"]').click()

    @$el.modal('hide')

  onLocalProgramClick: (e, program) ->
    @select(e.currentTarget, 'local', program)

  onDemoProgramClick: (e, program) ->
    @select(e.currentTarget, 'demo', program)

  onFindFromComputerClick: (e) ->
    @select(e.currentTarget, 'find-from-computer')

  select: (anchor, type, program = null) ->
    @unselect()
    $(anchor).addClass('active')
    @type = type
    @program = program

  unselect: ->
    @$el.find('a.thumbnail').removeClass('active')

  programToHtml: (program, onclick) ->
    if program.imageUrl
      img = "<img src=\"#{program.imageUrl}\">"
    else
      img = "<h1 class=\"icon\"><i class=\"icon-file\" /></h1>"

    html = """
    <li>
      <a class="thumbnail">
        #{img}
        <blockquote>
          <p>
            #{program.title}
          </p>
          <small>#{program.filename}</small>
        </blockquote>
      </div>
    </li>
    """

    html = $(html)
    html.find('a.thumbnail').click (e) =>
      e.preventDefault()
      onclick.call(@, e, program)

    html
