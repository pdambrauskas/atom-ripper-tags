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
      default: false
  generator: null
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-ripper-tags:rebuild': => @rebuild()

    if @isRebuildOnChange()
      chokidar
        .watch(
          @pathsToWatch(),
          {
            ignoreInitial: true
            followSymlinks: false
            awaitWriteFinish: true
            usePolling: true
            interval: 10000
            binaryInterval: 9999999999 # Binary files are not watched
          }
        )
        .on('change', (event, path) => @rebuild())

  deactivate: ->
    subscriptions.dispose()
    chokidar.close()

  rebuild: ->
    generator.rebuild()

  pathsToWatch: ->
    atom.project.getPaths().map (path) -> path + '/**/*.rb'

  isRebuildOnChange: ->
    atom.config.get('atom-ripper-tags.rebuildOnFileChange')
