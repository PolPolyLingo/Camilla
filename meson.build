# Project Setting
project('camilla', ['vala', 'c'],
        version: '0.1.0',
        meson_version: '>=0.43',
        license:'Apache License 2.0',
)

add_project_arguments([
        '-Wno-discarded-qualifiers',
        '-Wno-incompatible-pointer-types',
        '-Wno-unused',
        ],
        language: 'c',
)

# Compiler Setting
cc = meson.get_compiler('c')
valac = meson.get_compiler('vala')
libvala_version = run_command(valac.cmd_array()[0], '--api-version').stdout().strip()
posix_dep = valac.find_library('posix')
libvala_required_version = '>= 0.40.4'
libvala_dep = dependency('libvala-@0@'.format(libvala_version), version: libvala_required_version)

dependencies = [
    dependency('glib-2.0', version: '>=2.62'),
    dependency('gobject-2.0'),
    dependency('gmodule-2.0'),
    dependency('gio-2.0'),
    dependency('gee-0.8'),
    #meson.get_compiler('vala').find_library('linux'),
    meson.get_compiler('vala').find_library('posix'),
]

# Build and Test target directory
subdir('src')
subdir('test')

# Manpages build & install setting
build_man_pages= find_program('scripts/mkman.sh')
run_command(build_man_pages)
meson.add_install_script('scripts/installer.sh')
