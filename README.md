# pubver
CLI tool to set/bump the `version` key in pubspec.yaml. Semver-compliant\*.

## Installing
You can install the package from the command line:
```
pub global activate pubspec_version
```

This will add the **pubver** binary to your `~/.pub-cache/bin`.
## Usage
### Bumping the version
```
pubver bump <part>
``` 
where `<part>` can be either **breaking**, **major**, **minor** or **patch**.

#### Examples
Before | Command | After
--- | --- | ---
1.2.3 | `pubver bump breaking`  | 2.0.0
0.2.1 | `pubver bump breaking`  | 0.3.0
0.2.1 | `pubver bump major`     | 1.0.0
0.2.1 | `pubver bump minor`     | 0.3.0
0.2.1 | `pubver bump patch`     | 0.2.2

### Setting the version
```
pubver set <version>
```
where `<version>` can be any arbitrary version.

### Getting the version
```
pubver get
```

### Output
The tool prints the new version to stdout. This allows post processing, e.g. making a git commit.
```bash
git ci . -m "Release $(pubver bump breaking)"
```
```
pubver set "$(pubver get)+1"
```

___
\*almost. It uses [pub_semver](https://pub.dartlang.org/packages/pub_semver) which is a bit different.
