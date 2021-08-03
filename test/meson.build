test_name = meson.project_name() + '-test'

test_sources = files([
	'log4vala/AbstractTestCase.vala',
	'log4vala/TestRunner.vala',
	'log4vala/Config.test.vala',
	'log4vala/Level.test.vala',
	'log4vala/Logger.test.vala',
	'log4vala/LoggerConfig.test.vala',
	'log4vala/Layout.DescriptiveLayout.test.vala',
	'log4vala/Layout.PatternLayout.test.vala',
	'log4vala/Layout.SimpleLayout.test.vala',
])
test_sources += log4vala_sources
test_sources += camilla_sources

test_deps = dependencies

tests = executable(
    test_name,
    sources: test_sources,
    dependencies: test_deps,
    install: false
)

test('tests', tests)
