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
    rebuildInterval:
      type: 'integer'
      default: 600

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-ripper-tags:rebuild': => @rebuild()

    if @isRebuildOnChange()
      @watchChanges()

    rebuildInterval = @getRebuildInterval() * 1000
    if rebuildInterval > 0
      setInterval((=> @rebuild()), rebuildInterval)

  watchChanges: ->
    chokidar
      .watch(
        @getPathsToWatch(),
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

  getPathsToWatch: ->
    atom.project.getPaths().map (path) -> path + '/**/*.rb'

  isRebuildOnChange: ->
    atom.config.get('atom-ripper-tags.rebuildOnFileChange')

  getRebuildInterval: ->
    atom.config.get('atom-ripper-tags.rebuildInterval')
