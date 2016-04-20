{CompositeDisposable} = require 'atom'
chokidar = require 'chokidar'
generator = require './atom-ripper-tags-generator'

module.exports = AtomRipperTags =
  config:
    executablePath:
      type: 'string'
      default: '/usr/local/bin/'
    rebuildOnFileChange:
      type: 'boolean'
      default: true
  generator: null
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-ripper-tags:rebuild': => @rebuild()

    chokidar.watch(atom.project.getPaths(), { ignored: /[\/\\]\./ })
      .on('change', => @rebuild() if @isRebuildOnChange())

  deactivate: ->
    subscriptions.dispose()
    Chokidar.close()

  rebuild: ->
    generator.rebuild()

  isRebuildOnChange: ->
    atom.config.get('atom-ripper-tags.rebuildOnFileChange')
