A library for building REST APIs easily with Dart modeled after Express JS for Node Js.

The library is still a work in progress and open to contribution.

Created with StageHand - [license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Inspiration

Our inspiration is the simplicity of [express js][express] 👏.

## Installing

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  sevr: any
```

## Usage

A simple usage example:

```dart
import 'dart:io';

import 'package:sevr/sevr.dart';
import 'package:path/path.dart' as p;

main() {
  var serv = Sevr();

  //let sevr know to serve from the /web directory
  serv.use(Sevr.static('example/web'));

  //Use path to get directory of the files to serve on that route
  serv.get('/serve', [
    (ServRequest req, ServResponse res) {
      return res.status(200).sendFile(p.absolute('example/web/index.html'));
    }
  ]);

  //get request
  serv.get('/test', [
    (ServRequest req, ServResponse res) {
      return res.status(200).json({'status': 'ok'});
    }
  ]);

  //post request
  serv.post('/post', [
    (ServRequest req, ServResponse res) async {
      return res.status(200).json(req.body);
    }
  ]);

  // request parameters
  serv.get('/param/:username', [
    (ServRequest req, ServResponse res) {
      return res.status(200).json({'params': req.params});
    }
  ]);

  // query parameters
  serv.get('/query', [
    (ServRequest req, ServResponse res) {
      return res.status(200).json(req.query);
    }
  ]);

  //Upload Files
  serv.get('/upload', [
    (req, res) async {
      for (var i = 0; i < req.files.keys.length; i++) {
        //Handle your file stream as you see fit, write to file, pipe to a cdn etc --->
        var file = File(req.files[req.files.keys.toList()[i]].filename);
        await for (var data
            in req.files[req.files.keys.toList()[i]].streamController.stream) {
          if (data is String) {
            await file.writeAsString(data, mode: FileMode.append);
          } else {
            await file.writeAsBytes(data, mode: FileMode.append);
          }
        }
      }

      return res.status(200).json(req.body);
    }
  ]);

  //Bind server to port 4000
  serv.listen(4000, callback: () {
    print('Listening on port: ${4000}');
  });
}
```

#### Create Server Connection

Pass in the port of your choice in this case: 4000

```dart
serv.listen(4000, callback: () {
    print('Listening on port: ${4000}');
  });
```

#### Make Server Requests

- Create requests by passing in the desired route.
- Put route Controllers in a List of Functions (`ServRequest` is a helper class that binds to `HttpRequest`, while `ServResponse` binds to the response from the `HttpRequest` Stream).
- Set response status `res.status()`.

Other available request types:

- `PUT`
- `PATCH`
- `DELETE`
- `COPY`
- `HEAD`
- `OPTIONS`
- `LINK`
- `UNLINK`
- `PURGE`
- `LOCK`
- `UNLOCK`
- `PROFIND`
- `VIEW`

```dart
serv.get('/test', [
    (ServRequest req, ServResponse res) {
      return res.status(200).json({'status': 'ok'});
    }
  ]);

  serv.post('/post', [
    (ServRequest req, ServResponse res) async {
      return res.status(200).json(req.body);
    }
  ]);
```

#### Serve Files From Your Server

- First Let Sevr know where you want to serve the files from with `use()` .
- Here we used the `.absolute()` function from the [path][path] package, pass in the directory of your main file, in this case `index.html`.

```dart
  //let sevr know to serve from the /web directory
  serv.use(Sevr.static('example/web'));

  //Use path to get directory of the files to serve on that route
  serv.get('/serve', [
    (ServRequest req, ServResponse res) {
      return res.status(200).sendFile(p.absolute('example/web/index.html'));
    }
  ]);
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

## Contributing

Fork the repo, clone and raise your pull requests against the dev branch, We look forward to your your commits! 😀

[tracker]: https://github.com/a-oboh/dart-sevr/issues
[express]: https://expressjs.com/
[path]: https://pub.dev/packages/path
