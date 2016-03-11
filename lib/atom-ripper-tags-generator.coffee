{BufferedProcess} = require 'atom'
path = require 'path'

module.exports =
  rebuild: ->
    args = ['-R', "--tag-file=#{path.join(atom.project.getPaths()[0], '.tags')}"]
    execPath = atom.config.get('atom-ripper-tags.executablePath')
    command = path.join execPath, 'ripper-tags'
    new BufferedProcess({command, args, @errorCallback, @errorCallback})

  errorCallback: (error) =>
    atom.notifications.addError(error.toString())
