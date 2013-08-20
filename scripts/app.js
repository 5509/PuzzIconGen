(function() {
  var hoge;

  hoge = function() {
    console.log('hoge');
    return console.log('fugafuga');
  };

}).call(this);

(function() {
  var fuga;

  fuga = function() {
    return console.log('fuga');
  };

}).call(this);
