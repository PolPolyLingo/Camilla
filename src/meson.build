app_files = [
    files('core/ArgParser.vala',
          'core/File.vala',
          'core/Objects.vala',
          'core/Stdout.vala',
          'core/String.vala',
          'parser/DeleteComment.vala',
          'parser/CountLineOfCode.vala',
          'model/Class.vala',
          'model/Method.vala',
          'model/SourceCode.vala',
          'model/LineOfCode.vala',
          'Application.vala',
          'Camilla.vala'
          ),
]

dependencies = [
    dependency('glib-2.0', version: '>=2.62'),
    dependency('gobject-2.0'),
    dependency('gio-2.0'),
    dependency('gee-0.8'),
    #meson.get_compiler('vala').find_library('linux'),
    meson.get_compiler('vala').find_library('posix'),
]

camilla_deps = [
    libvala_dep,
    dependencies
]

executable(meson.project_name(),
           app_files,
           dependencies: [camilla_deps],
           install : true,
           install_dir : '/usr/local/bin')