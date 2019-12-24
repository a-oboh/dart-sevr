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

  // get request
  serv.get('/test',[(req,res){
    return res.status(200).json({'status':'ok'});
  }]);

  // post request
  serv.post('/post', [
    (req, res) async {
      print(req.body);
      return res.status(200).json(req.body);
    }
  ]);

  serv.listen(3000,callback: (){
    print('Listening on ${3000}');
  });
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

## Contributing

Fork the repo, clone and raise your pull requests against the dev branch, We look forward to your your commits! 😀

[tracker]: https://github.com/a-oboh/dart-sevr/issues
[express]: https://expressjs.com/
