app_files = [
    files('core/ArgParser.vala',
          'core/File.vala',
          'core/Objects.vala',
          'core/Stdout.vala',
          'core/String.vala',
          'model/AccessModifier.vala',
          'model/Class.vala',
          'model/LineOfCode.vala',
          'model/Namespace.vala',
          'model/Method.vala',
          'model/SourceCode.vala',
          'model/Struct.vala',
          'model/Variable.vala',
          'parser/CountLineOfCode.vala',
          'parser/DeleteComment.vala',
          'parser/SourceCodeParser.vala',
          'Application.vala',
          'Camilla.vala'
          ),
]

# fork log4vala from https://github.com/nmelnick/Log4Vala
log4vala_sources = files([
	'log4vala/Config.vala',
	'log4vala/Core.vala',
	'log4vala/Level.vala',
	'log4vala/LogEvent.vala',
	'log4vala/Logger.vala',
	'log4vala/LoggerCompat.vala',
	'log4vala/LoggerConfig.vala',
	'log4vala/Appender/IAppender.vala',
	'log4vala/Appender/FileAppender.vala',
	'log4vala/Appender/ScreenAppender.vala',
	'log4vala/Appender/SocketAppender.vala',
	'log4vala/Layout/ILayout.vala',
	'log4vala/Layout/DescriptiveLayout.vala',
	'log4vala/Layout/PatternLayout.vala',
	'log4vala/Layout/SimpleLayout.vala'
])
app_files += log4vala_sources

camilla_deps = [
    libvala_dep,
    dependencies
]

executable(meson.project_name(),
           app_files,
           dependencies: [camilla_deps],
           install : true,
           install_dir : '/usr/local/bin')