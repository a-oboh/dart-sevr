A library for building REST APIs easily with Dart modeled after Express JS for Node Js.

The library is still a work in progress and open to contribution.

Created with StageHand - [license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Inspiration

Our inspiration is the simplicity of [express js][express] 👏.

## Usage

A simple usage example:

```dart
import 'package:sevr/sevr.dart';

main() {
  var serv = Sevr();

  //first notify **sevr** of your directory of static files
  serv.use(Sevr.static('./web'));

  //create controller,middleware classes etc, put them in a list and pass them into the router methods

  //serve files from the port
  serv.get('/file', [
    (ServRequest req, ServResponse res) {
      return res.status(200).sendFile(p.absolute('web/index.html'));
    }
  ]);

  // get request that returns json
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

  //create server connection
  serv.listen(4000, callback: () {
    print('Listening on port: ${4000}');
  });
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

## Contributing

Fork the repo, clone and raise your pull requests against the dev branch, We look forward to your your commits! 😀

[tracker]: https://github.com/a-oboh/dart-sevr/issues
[express]: https://expressjs.com/
