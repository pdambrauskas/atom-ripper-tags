{BufferedProcess} = require 'atom'
path = require 'path'
exec = require('child_process').exec

module.exports =
  rebuild: ->
    projectPath = atom.project.getPaths()[0]
    args = [
      '-R',
      "--tag-file=#{path.join(projectPath, '.tags')}",
      '--recursive',
      '--tag-relative',
      '--force',
    ]

    execPath = atom.config.get('atom-ripper-tags.executablePath')
    command = "cd #{projectPath}; #{path.join(execPath, 'ripper-tags')} #{args.join(' ')}"
    exec command, @errorCallback

  errorCallback: (error) =>
    atom.notifications.addError(error) if error
