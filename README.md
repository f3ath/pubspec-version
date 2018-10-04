# pubspec-version
A CLI tool to set/bump the `version` key in pubspec.yaml. Semver-compliant\*.

## Usage
### Bumping the version
Run `pubspec-version bump <part>` to increment the version. 
`<part>` can be either `breaking`, `major`, `minor`, or `patch`.

E.g. if the current package version is `1.2.3`, running `pubspec-version bump minor` will set it to `1.3.0`.

### Setting the version
Run `pubspec-version set <version>` to set the version to `<version>`.

### Options
- `-d <pubspec_directory>` provides the path to the directory containing `pubspec.yaml`. 
Defaults to the current directory.
- `-c` also does `git commit . 'Release <version>'` and `git tag <version>`. Think of `npm version` for Dart.

### Output
The tool prints the new version to stdout.

___
\*almost. It uses [pub_semver](https://pub.dartlang.org/packages/pub_semver) which is a bit different.
