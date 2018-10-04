# pubspec-version
A CLI tool to set/bump the `version` key in pubspec.yaml. Semver-compliant*.

## Usage
### Bumping the version
Run `pubspec-version bump <part>` to increment the version. 
`<part>` can be either `breaking`, `major`, `minor`, or `patch`.

E.g. if the current package version is `1.2.3`, running `pubspec-version bump minor` will set it to `1.3.0`.

### Setting the version
Run `pubspec-version set <version>` to set the version to `<version>`.

### Options
- `-c <path-to-pubspec>` provides the path to pubspec.yaml.

### Output
The tool prints the new version to stdout so it can be used later, e.g. in `git tag`.
```bash
git tag $(pubspec-version bump)
```

___
*almost. It uses [pub_semver](https://pub.dartlang.org/packages/pub_semver) which it a bit different.
